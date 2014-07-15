#!/bin/bash

mkdir build
cd build

cmake \
    -D WITH_PYTHON:BOOL=ON \
    -D GMP_INCLUDE_DIR="$PREFIX/include" \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    ..

make
make install
