#!/bin/sh
# might require sudo
# todo: verify host fs permissions:
# /data/db/mongo/{configdb,db,logs(777),config/mongod.conf}
DIR=${0%/*}
CONFIG_FILE="$DIR/mongod.conf"
MONGO_DIR="/data/db/mongo"
[ -d $MONGO_DIR/config ] || mkdir -p $MONGO_DIR/config
cp $CONFIG_FILE $MONGO_DIR/config/
touch $MONGO_DIR/logs/mongod.log
chown $USER:$USER $MONGO_DIR/logs/mongod.log
chmod 666 $MONGO_DIR/logs/mongod.log
