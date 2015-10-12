#!/bin/bash

if [[ `uname` == "Darwin" ]]; then
    # This enables Xcode support for C++11, that is needed for CSymPy.
    export MACOSX_DEPLOYMENT_TARGET=10.9
fi

mkdir build
cd build

cmake \
    -D WITH_PYTHON:BOOL=ON \
    -D COMMON_DIR=$PREFIX \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D BUILD_TESTS=no \
    -D BUILD_BENCHMARKS=no \
    ..

make
make install
