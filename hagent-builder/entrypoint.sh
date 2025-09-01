#!/usr/bin/env bash

set -euo pipefail

# ---------------------------
# Helpers (pure bash/posix)
# ---------------------------

is_root() { [ "$(id -u)" = "0" ]; }

have_cmd() { command -v "$1" >/dev/null 2>&1; }

# Extract mount points (field 5) from /proc/self/mountinfo
mountpoints_under() {
  # $1: prefix dir (e.g., /code/workspace)
  # Outputs absolute mountpoints whose path starts with the prefix (including the prefix itself).
  awk -v pref="$1" '($5 ~ ("^" pref "(/|$)")) {print $5}' /proc/self/mountinfo 2>/dev/null || true
}

# True if there exists a mount strictly *inside* $1 (i.e., /dir/something, not /dir itself)
has_nested_mounts() {
  local base="$1"
  local mp
  while IFS= read -r mp; do
    [ "$mp" = "$base" ] && continue
    case "$mp" in
    "$base"/*) return 0 ;;
    esac
  done < <(mountpoints_under "$base")
  return 1
}

safe_chown_recursive_if_no_mounts() {
  # $1: path, $2: user:group
  local path="$1" ug="$2"
  if has_nested_mounts "$path"; then
    echo "INFO: Skipping recursive chown of $path (nested mounts detected)" >&2
    chown "$ug" "$path"
  else
    echo "INFO: chown -R $ug $path" >&2
    chown -R "$ug" "$path"
  fi
}

start_mcp_servers() {
  # Start optional MCP servers (non-root or root path). Keep minimal, trap PIDs if any are started.
  echo "Starting MCP servers..." >&2
  local pids=()

  if [ -f /opt/mcp-servers/hagent/index.js ]; then
    node /opt/mcp-servers/hagent/index.js &
    pids+=("$!")
    echo "Started hagent MCP server (PID: ${pids[-1]})" >&2
  else
    echo "Warning: hagent MCP server not found" >&2
  fi

  if [ -f /opt/mcp-servers/filesystem/index.js ]; then
    node /opt/mcp-servers/filesystem/index.js /workspace /code /app &
    pids+=("$!")
    echo "Started filesystem MCP server (PID: ${pids[-1]})" >&2
  else
    echo "Warning: filesystem MCP server not found" >&2
  fi

  # shellcheck disable=SC2064
  trap "kill ${pids[*]:-} 2>/dev/null || true" EXIT INT TERM
  if [ "${#pids[@]}" -gt 0 ]; then
    echo "MCP servers running. Press Ctrl+C to stop." >&2
    wait "${pids[@]}"
  else
    echo "No MCP servers started; exiting." >&2
  fi
}

# ---------------------------
# Mode selection
# ---------------------------

MCP_MODE=false
if [ $# -gt 0 ] && [ "${1:-}" = "mcp" ]; then
  MCP_MODE=true
  shift
fi

# ---------------------------
# Non-root fast path
# ---------------------------

if ! is_root; then
  echo "Not running as root (UID: $(id -u)), skipping user/group setup" >&2
  if $MCP_MODE; then
    # Run MCP servers in foreground as current user
    start_mcp_servers
  elif [ $# -gt 0 ]; then
    exec bash --login -c "$*"
  else
    exec bash --login
  fi
fi

# ---------------------------
# Root path: prerequisites
# ---------------------------

have_cmd su-exec || {
  echo "ERROR: su-exec not found"
  exit 1
}
have_cmd bash || {
  echo "ERROR: bash not found"
  exit 1
}

# ---------------------------
# Target IDs (defaults)
# ---------------------------

USER_NAME="user"   # existing unprivileged user baked in the image
GROUP_NAME="guser" # existing group baked in the image

TARGET_UID="${LOCAL_USER_ID:-9001}"
TARGET_GID="${LOCAL_GROUP_ID:-9001}"

# ---------------------------
# Resolve group: reuse if GID exists, else retag GROUP_NAME
# ---------------------------

EXISTING_GROUP_NAME=""
if getent group "$TARGET_GID" >/dev/null 2>&1; then
  # If a group already uses TARGET_GID, reuse it (do not create/retag another).
  EXISTING_GROUP_NAME="$(getent group "$TARGET_GID" | cut -d: -f1)"
  echo "INFO: Reusing existing group GID=$TARGET_GID ($EXISTING_GROUP_NAME)" >&2
  # Make it the primary group for USER_NAME.
  usermod -g "$EXISTING_GROUP_NAME" "$USER_NAME"
else
  # No conflict; set primary group to TARGET_GID by retagging GROUP_NAME.
  if [ "$TARGET_GID" != "$(getent group "$GROUP_NAME" | cut -d: -f3)" ]; then
    echo "INFO: Setting $GROUP_NAME GID -> $TARGET_GID" >&2
    groupmod -g "$TARGET_GID" "$GROUP_NAME"
  fi
  EXISTING_GROUP_NAME="$GROUP_NAME"
fi

# Make primary group consistent (if we reused a foreign group, ensure primary reflects it)
PRIMARY_GID_FOR_USER="$(id -g "$USER_NAME")"
TARGET_PRIMARY_GID="$(getent group "$EXISTING_GROUP_NAME" | cut -d: -f3)"
if [ "$PRIMARY_GID_FOR_USER" != "$TARGET_PRIMARY_GID" ]; then
  usermod -g "$EXISTING_GROUP_NAME" "$USER_NAME"
fi

# ---------------------------
# Resolve user
# ---------------------------

CURRENT_UID="$(id -u "$USER_NAME")"
if [ "$CURRENT_UID" != "$TARGET_UID" ]; then
  # -o allows multiple users with same UID
  usermod -o -u "$TARGET_UID" "$USER_NAME"

  # Update the homedirectory to new ID
  safe_chown_recursive_if_no_mounts "/home/user" "${USER_NAME}:${EXISTING_GROUP_NAME}"

  # 1) /app: recursive chown ONLY if there are no nested mounts inside /app
  if [ -d /app ]; then
    safe_chown_recursive_if_no_mounts "/app" "${USER_NAME}:${EXISTING_GROUP_NAME}"
  fi

  # Optional quality-of-life: ensure /code and /workspace (if present) bases are owned (non-recursive)
  for d in /code/workspace/*; do
    if [ -d "$d" ]; then
      safe_chown_recursive_if_no_mounts "$d" "${USER_NAME}:${EXISTING_GROUP_NAME}"
    fi
  done
fi

# ---------------------------
# Execute requested mode/command
# ---------------------------

if $MCP_MODE; then
  # Run MCP servers as the unprivileged user
  exec su-exec "$USER_NAME" bash --login -c '
    set -euo pipefail
    export HAGENT_CONFIG_PATH="${HAGENT_CONFIG_PATH:-/workspace/hagent.yaml}"
    export NODE_ENV=production
    pids=()

    if [ -f /opt/mcp-servers/hagent/index.js ]; then
      node /opt/mcp-servers/hagent/index.js & pids+=("$!")
      echo "Started hagent MCP server (PID: ${pids[-1]})" >&2
    fi

    if [ -f /opt/mcp-servers/filesystem/index.js ]; then
      node /opt/mcp-servers/filesystem/index.js /workspace /code /app & pids+=("$!")
      echo "Started filesystem MCP server (PID: ${pids[-1]})" >&2
    fi

    trap "kill ${pids[*]:-} 2>/dev/null || true" EXIT INT TERM
    if [ "${#pids[@]}" -gt 0 ]; then
      echo "MCP servers running. Press Ctrl+C to stop." >&2
      wait "${pids[@]}"
    else
      echo "No MCP servers started; exiting." >&2
    fi
  '
elif [ $# -gt 0 ]; then
  exec su-exec "$USER_NAME" bash --login -c "$*"
else
  exec su-exec "$USER_NAME" bash --login
fi
