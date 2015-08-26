#!/bin/bash

./configure --prefix=$PREFIX --enable-linux-lfs --with-zlib=$PREFIX --with-ssl --enable-cxx
make
make install

rm -rf $PREFIX/share/hdf5_examples
