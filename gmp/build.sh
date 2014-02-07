#!/bin/bash

chmod +x configure

./configure --prefix=$PREFIX --disable-shared

make
make check
make install
