#!/bin/bash

$PYTHON setup.py install

rm -rf $PREFIX/share
rm -rf $SP_DIR/share
rm -rf $SP_DIR/ipython-*.egg*/share

if [ $PY3K == 1 ]; then
    rm -rf $PREFIX/bin
fi
