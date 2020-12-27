#!/bin/sh

MONGO_DIR="/data/db/mongo"
echo "config: $MONGO_DIR/configdb"
docker stop mongo > /dev/null 2>&1
docker rm -f mongo > /dev/null 2>&1
docker run \
    -d \
    --name mongo \
    --restart=always \
    -m 3g \
    -p 127.0.0.1:27017:27017 \
    -v $MONGO_DIR/db:/data/db \
    -v $MONGO_DIR/config:/data/config \
    -v $MONGO_DIR/logs:/data/logs \
    -v $MONGO_DIR/configdb:/data/configdb \
    mongo:4.4 \
        --setParameter cursorTimeoutMillis=3200000 \
        --setParameter disableJavaScriptJIT=false \
        --config /data/config/mongod.conf
