#!/bin/sh

./configure \
    --prefix=$PREFIX \
    --with-python \
    --with-openssl \
    --with-libxml

make
make install
