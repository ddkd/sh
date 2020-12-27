#!/usr/bin/env sh

# apt-get install software-properties-common
# add-apt-repository ppa:deadsnakes/ppa
# apt-get update
apt-get install -y python3 python3-pip
ln -sf python3 /usr/bin/python
ln -sf pip3 /usr/bin/pip

apt-get install -y build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    wget