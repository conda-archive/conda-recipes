#!/bin/bash

chmod +x configure

./configure --prefix=$PREFIX 

make -j
make install
