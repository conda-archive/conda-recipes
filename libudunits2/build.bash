#!/bin/bash
export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

./configure \
    --enable-shared \
    --prefix=$PREFIX
make
make install
