#!/bin/bash
export CC=gcc44
export CXX=g++44
export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

./configure prefix=$PREFIX
make -j 4
#make test
make install
