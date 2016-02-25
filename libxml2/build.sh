#!/bin/bash

if [ `uname` == Darwin ]; then
    export EXTRA_ARGS="--without-threads"
fi

./configure $EXTRA_ARGS --prefix=$PREFIX --without-python
make -j${CPU_COUNT}
make install
