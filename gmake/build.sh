#!/bin/bash

# clang fails on unused arguments
CC=cc CXX=g++ CFLAGS="-Qunused-arguments" ./configure --prefix=$PREFIX
make
make install
