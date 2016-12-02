#!/bin/bash

if [[ $(uname) == Darwin ]]; then
    EXTRA_ARGS="--without-threads"
fi

./configure $EXTRA_ARGS --prefix=$PREFIX --without-python --with-iconv=$PREFIX --without-lzma
make -j${CPU_COUNT}
make install
