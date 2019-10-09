#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

# FIXME: find mount directory and add user automatically
#  docker run -it -v $HOME:/home/potato mascucsc/archlinux-masc
#  to get uid: stat -c '%u' /home/*
#  to get gid: stat -c '%g' /home/*

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
groupadd -g ${USER_ID} guser
useradd  -m -p user -s /bin/bash -u $USER_ID -G guser user
echo "user ALL=(ALL) ALL" >>/etc/sudoers

export HOME=/home/user

exec /bin/su - user

