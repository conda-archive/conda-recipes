#!/bin/bash

if [ `uname` == Darwin ]; then
    export CFLAGS="-DWITH_NEXT_FRAMEWORK $CFLAGS"
fi

cp setup.cfg.template setup.cfg || exit 1

$PYTHON setup.py install

rm -rf $SP_DIR/PySide
