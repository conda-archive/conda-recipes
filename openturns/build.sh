#!/bin/bash

# Build dependencies:
# - gcc
# - g++
# - gfortran
# - flex
# - bison
# - libtbb-dev
# - r-base-core
# - liblapack-dev
# - libmuparser-dev
# - libboost-math-dev
# - python-dev

mkdir build
cd build
cmake \
    -DLIBXML2_LIBRARIES=$PREFIX/lib/libxml2.so \
    -DLIBXML2_INCLUDE_DIR=$PREFIX/include/libxml2 \
    -DPYTHON_EXECUTABLE=$PREFIX/bin/python \
    -DPYTHON_LIBRARY=$PREFIX/lib/libpython2.7.so \
    -DPYTHON_INCLUDE_DIR=$PREFIX/include/python2.7/ \
    -DCMAKE_INSTALL_PREFIX=$PREFIX/ \
    ..
make -j -C lib
make install
