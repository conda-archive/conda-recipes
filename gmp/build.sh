#!/bin/bash

chmod +x configure

./configure --prefix=$PREFIX --disable-static

make
make check
make install
