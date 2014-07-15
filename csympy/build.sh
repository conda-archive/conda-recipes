#!/bin/bash

mkdir build
cd build

cmake \
    -D WITH_PYTHON:BOOL=ON \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    ..

make
make install
