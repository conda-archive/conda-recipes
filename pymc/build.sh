#!/bin/bash
export CFLAGS="-arch x86_64"
export FFLAGS="-static -ff2c -arch x86_64"
export LDFLAGS="-Wall -undefined dynamic_lookup -bundle -arch x86_64"
export CC=gcc-4.2
export CXX=g++-4.2

$PYTHON setup.py install

