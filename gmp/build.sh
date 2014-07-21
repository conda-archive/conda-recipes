#!/bin/bash

chmod +x configure

if [ `uname` == Darwin ]; then
    ./configure --prefix=$PREFIX
else
    ./configure --prefix=$PREFIX
fi

make
make check
make install
