#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
#useradd -s /bin/bash -u $USER_ID -o -c "" -m user
addgroup -g ${USER_ID} user
adduser -D -s /bin/bash -u $USER_ID -G user user
export HOME=/home/user

exec /usr/local/bin/su-exec user "$@"
