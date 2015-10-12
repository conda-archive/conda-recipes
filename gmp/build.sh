#!/bin/bash

chmod +x configure

if [ `uname` == Darwin ]; then
    ./configure --prefix=$PREFIX --enable-cxx
else
    ./configure --prefix=$PREFIX --enable-cxx
fi

make
make check
make install
