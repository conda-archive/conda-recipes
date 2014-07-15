#!/bin/bash

chmod +x configure

if [ `uname` == Darwin ]; then
    export MACOSX_DEPLOYMENT_TARGET=10.9
    ./configure --prefix=$PREFIX --disable-shared --enable-cxx
else
    ./configure --prefix=$PREFIX
fi

make
make check
make install
