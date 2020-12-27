#!/bin/sh

DIR=${0%/*}
NAME=${1:-"ubuntu"}
FULL_NAME="jupyter-$NAME"
CONTAINER_NAME="jupyter"

# todo: build if image not exists
DATA_DIR=${DATA_DIR:-'/data/jupyter'}
NOTEBOOKS_DIR=${NOTEBOOKS_DIR:-"$DATA_DIR/notebooks"}
[ -d $NOTEBOOKS_DIR ] || mkdir -p $NOTEBOOKS_DIR

# todo: ask if already running
docker stop $CONTAINER_NAME > /dev/null 2>&1
docker rm -f $CONTAINER_NAME > /dev/null 2>&1
docker run \
    --restart=always \
    --name $CONTAINER_NAME \
    -d \
    -m 2g -p 127.0.0.1:8888:8888 \
    -v $NOTEBOOKS_DIR:/notebooks \
    $FULL_NAME