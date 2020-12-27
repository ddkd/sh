#!/bin/bash

TMPDIR=${TMPDIR:/tmp}
FILE=$(mktemp $TMPDIR/tosubl-XXXXXXXX)
cat >| $FILE
subl $FILE
sleep 1
rm -f $FILE
