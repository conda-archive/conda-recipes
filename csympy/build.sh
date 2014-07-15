#!/bin/bash

if [[ `uname` == "Darwin" ]]; then
    # This enables Xcode support for C++11, that is needed for CSymPy.
    export MACOSX_DEPLOYMENT_TARGET=10.9
fi

mkdir build
cd build

cmake \
    -D WITH_PYTHON:BOOL=ON \
    -D GMP_INCLUDE_DIR="$PREFIX/include" \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    ..

make
make install
