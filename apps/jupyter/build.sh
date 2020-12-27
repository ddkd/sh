#!/bin/sh

DIR=${0%/*}
NAME=${1:-"ubuntu"}
FULL_NAME="jupyter-$NAME"
PROJECT_ROOT="$DIR/../../"

ARGS="-t $FULL_NAME:latest"
ARGS="$ARGS -f $DIR/$FULL_NAME.dockerfile"
[ -f "$PROJECT_ROOT/apps/build-secrets.env" ] && \
    ARGS="$ARGS --secret id=build-secrets,src=$PROJECT_ROOT/apps/build-secrets.env"

# ARGS="$ARGS --no-cache"
# ARGS="$ARGS --progress=plain"
ARGS="$ARGS $PROJECT_ROOT/scripts"

echo "building $FULL_NAME"
docker build $ARGS
