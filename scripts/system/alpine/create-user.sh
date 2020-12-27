#!/usr/bin/env sh

SECRETS_FILE=${SECRETS_FILE:-'/run/build-secrets.env'}
[ -f "$SECRETS_FILE" ] && . $SECRETS_FILE

USERNAME=${USERNAME:-'app'}
DIR=${DIR:-'/app'}
PASSWORD=${USER_PASSWORD:-$USERNAME} # optional from build-secrets.env
GROUPNAME=${GROUPNAME:-"$USERNAME"}
ARGS='-D' # don't assign password
if [ `which bash` ]; then
    ARGS="$ARGS -s /bin/bash"
fi
if [ "$DIR" ]; then
    ARGS="$ARGS -h $DIR"
fi
# echo "(${0##*/}) adduser $USERNAME $GROUPNAME $ARGS"
adduser $USERNAME $GROUPNAME $ARGS
if [ "$SUDO" ]; then
    apk add sudo
    echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
    # usermod -a -G wheel $USERNAME
    addgroup $USERNAME wheel
    echo "(${0##*/}) added user to sudoers"
fi
if [ "$USER_PASSWORD" ]; then
    echo "(${0##*/}) overriding user password"
else
    echo "(${0##*/}) using default user password"
fi
echo $USERNAME:$PASSWORD | chpasswd >> /dev/null 2>&1

