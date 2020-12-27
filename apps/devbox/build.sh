#!/bin/sh

DIR=${0%/*}
NAME=${1:-"alpine"}
FULL_NAME="devbox-$NAME"
PROJECT_ROOT="$DIR/../../"

ARGS="-t $FULL_NAME:latest"
ARGS="$ARGS -f $DIR/$FULL_NAME.dockerfile"
[ -f "$PROJECT_ROOT/apps/build-secrets.env" ] && \
    ARGS="$ARGS --secret id=build-secrets,src=$PROJECT_ROOT/apps/build-secrets.env"

# ARGS="$ARGS --progress=plain"
ARGS="$ARGS $PROJECT_ROOT/scripts"

echo "building $FULL_NAME"
docker build $ARGS
