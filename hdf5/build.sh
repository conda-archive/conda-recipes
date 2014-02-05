#!/bin/bash

./configure --prefix=$PREFIX --disable-static \
    --enable-linux-lfs --with-zlib --with-ssl
make
make install

rm -rf $PREFIX/share/hdf5_examples
