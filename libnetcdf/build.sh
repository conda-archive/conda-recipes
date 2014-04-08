#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

./configure \
    --enable-shared \
    --enable-netcdf-4 \
    --enable-dap \
    --without-ssl \
    --without-libidn \
    --disable-ldap \
    --prefix=$PREFIX
make
make install

rm -rf $PREFIX/share
