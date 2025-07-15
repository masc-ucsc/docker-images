#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" != "0" ]; then
  echo "Not running as root (UID: $(id -u)), skipping user setup"

  # Just exec the command directly without su-exec
  if [ $# -gt 0 ]; then
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

if [ "$USER_ID" != "9001" ]; then
  echo "Changing UID to $USER_ID"
  usermod -u "$USER_ID" user
  chown -R user:guser /code /app
fi

# If the container was given a command, pass it to `bash -c …`,
# otherwise just drop you into an interactive login shell.

if [ $# -gt 0 ]; then
  exec su-exec user bash --login -c "$*"
else
  exec su-exec user bash --login
fi
