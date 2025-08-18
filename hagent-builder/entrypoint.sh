#!/usr/bin/env bash
set -euo pipefail

# Function to start MCP servers
start_mcp_servers() {
  echo "Starting MCP servers..." >&2

  # Start hagent MCP server
  if [ -f /opt/mcp-servers/hagent/index.js ]; then
    node /opt/mcp-servers/hagent/index.js &
    HAGENT_PID=$!
    echo "Started hagent MCP server (PID: $HAGENT_PID)" >&2
  else
    echo "Warning: hagent MCP server not found" >&2
  fi

  # Start filesystem MCP server with workspace access
  if [ -f /opt/mcp-servers/filesystem/index.js ]; then
    node /opt/mcp-servers/filesystem/index.js /workspace /code /app &
    FS_PID=$!
    echo "Started filesystem MCP server (PID: $FS_PID)" >&2
  else
    echo "Warning: filesystem MCP server not found" >&2
  fi

  # Setup signal handlers to cleanup on exit
  trap "kill $HAGENT_PID $FS_PID 2>/dev/null || true" EXIT INT TERM

  # Wait for servers
  wait $HAGENT_PID $FS_PID
}

# Check if first argument is "mcp"
if [ $# -gt 0 ] && [ "$1" = "mcp" ]; then
  MCP_MODE=true
  shift # Remove "mcp" from arguments
else
  MCP_MODE=false
fi

if [ "$(id -u)" != "0" ]; then
  echo "Not running as root (UID: $(id -u)), skipping user setup"

  if [ "$MCP_MODE" = true ]; then
    # Run MCP servers as non-root user
    start_mcp_servers
  elif [ $# -gt 0 ]; then
    # Just exec the command directly without su-exec
    exec bash --login -c "$*"
  else
    exec bash --login
  fi
fi

# su-exec must be present
command -v su-exec >/dev/null ||
  {
    echo "ERROR: su-exec not found"
    exit 1
  }

# bash must be present
command -v bash >/dev/null ||
  {
    echo "ERROR: bash not found"
    exit 1
  }

# ——————————————————————————————————————————————————————
# Create the unprivileged user "user" with a fixed UID if needed
# ——————————————————————————————————————————————————————

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}

if [ "$USER_ID" != "9001" ] || [ "$GROUP_ID" != "9001" ]; then
  if [ "$USER_ID" != "9001" ]; then
    echo "Changing UID to $USER_ID"
    usermod -u "$USER_ID" user
  fi
  
  if [ "$GROUP_ID" != "9001" ]; then
    echo "Changing GID to $GROUP_ID"
    groupmod -g "$GROUP_ID" guser
    usermod -g "$GROUP_ID" user
  fi
  
  chown -R user:guser /code /app
fi

# Handle MCP mode or regular commands
if [ "$MCP_MODE" = true ]; then
  # Run MCP servers as the unprivileged user
  exec su-exec user bash --login -c "
    echo 'Starting MCP servers as user (UID: \$(id -u))...' >&2

    # Export any needed environment variables
    export HAGENT_CONFIG_PATH=\${HAGENT_CONFIG_PATH:-/workspace/hagent.yaml}
    export NODE_ENV=production

    # Start hagent MCP server
    if [ -f /opt/mcp-servers/hagent/index.js ]; then
      node /opt/mcp-servers/hagent/index.js &
      HAGENT_PID=\$!
      echo \"Started hagent MCP server (PID: \$HAGENT_PID)\" >&2
    fi

    # Start filesystem MCP server
    if [ -f /opt/mcp-servers/filesystem/index.js ]; then
      node /opt/mcp-servers/filesystem/index.js /workspace /code /app &
      FS_PID=\$!
      echo \"Started filesystem MCP server (PID: \$FS_PID)\" >&2
    fi

    # Setup cleanup
    trap 'kill \$HAGENT_PID \$FS_PID 2>/dev/null || true' EXIT INT TERM

    # Wait for servers
    echo 'MCP servers running. Press Ctrl+C to stop.' >&2
    wait \$HAGENT_PID \$FS_PID
  "
elif [ $# -gt 0 ]; then
  # If the container was given a command, pass it to `bash -c …`
  exec su-exec user bash --login -c "$*"
else
  # otherwise just drop you into an interactive login shell
  exec su-exec user bash --login
fi
