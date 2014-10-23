#!/bin/bash

mkdir $PREFIX/lib

sh ./configure --prefix=$PREFIX \
    --without-debug --without-ada --without-manpages \
    --with-shared --disable-overwrite


make -j$(getconf _NPROCESSORS_ONLN)
make install
