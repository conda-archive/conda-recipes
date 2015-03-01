#!/bin/bash

./configure --prefix=$PREFIX --enable-linux-lfs --enable-cxx --with-zlib=$PREFIX --with-ssl
make
make install

rm -rf $PREFIX/share/hdf5_examples
