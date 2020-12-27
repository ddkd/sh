#!/usr/bin/env sh

apk add --update --no-cache python3
ln -sf python3 /usr/bin/python
python -m ensurepip
ln -sf pip3 /usr/bin/pip
pip install --no-cache --upgrade pip setuptools
