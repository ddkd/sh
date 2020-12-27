#!/usr/bin/env sh

SECRETS_FILE=${SECRETS_FILE:-'/run/build-secrets.env'}
[ -f "$SECRETS_FILE" ] && . $SECRETS_FILE

if [ "$ROOT_PASSWORD" ]; then
    echo "(${0##*/}) overriding root password"
    echo root:$ROOT_PASSWORD | chpasswd >> /dev/null 2>&1
else
    echo "(${0##*/}) root password unchanged"
fi
