#!/usr/bin/env sh

echo "(${0##*/}) path to me:  ${0}"
echo "(${0##*/}) parent path:  ${0%/*}"
echo "(${0##*/}) arguments:  ${@}"
echo "(${0##*/}) \$1:  $1"
echo "(${0##*/}) \$2:  $2"
