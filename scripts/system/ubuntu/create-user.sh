#!/usr/bin/env sh

SECRETS_FILE=${SECRETS_FILE:-'/run/build-secrets.env'}
[ -f "$SECRETS_FILE" ] && . $SECRETS_FILE

USERNAME=${USERNAME:-'app'}
DIR=${DIR:-'/app'}
PASSWORD=${USER_PASSWORD:-$USERNAME} # optional from build-secrets.env
GROUPNAME=${GROUPNAME:-"$USERNAME"}
ARGS=''
if [ `which bash` ]; then
    ARGS="$ARGS --shell /bin/bash"
fi
if [ "$DIR" ]; then
    ARGS="$ARGS --home $DIR"
fi
echo "(${0##*/}) useradd $USERNAME $ARGS"
useradd $USERNAME $ARGS
if [ "$SUDO" ]; then
    apt-get update
    apt-get install -y sudo
    usermod -aG sudo $USERNAME
    echo "(${0##*/}) added user to sudoers"
fi
if [ "$USER_PASSWORD" ]; then
    echo "(${0##*/}) overriding user password"
else
    echo "(${0##*/}) using default user password"
fi
echo $USERNAME:$PASSWORD | chpasswd >> /dev/null 2>&1

