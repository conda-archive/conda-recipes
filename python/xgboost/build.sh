#!/usr/bin/env bash

# To use OpenMP
if [[ `uname` == Darwin ]]; then
    export CC=gcc
    export CXX=g++
fi

./build.sh

cd python-package
python setup.py install