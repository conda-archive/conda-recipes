#!/bin/bash

chmod +x configure

if [ `uname` == Darwin ]; then
    ./configure --prefix=$PREFIX --disable-shared
else
    ./configure --prefix=$PREFIX
fi

make
make check
make install
