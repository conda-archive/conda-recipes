#!/bin/bash

chmod +x configure

./configure --prefix=$PREFIX \
    --with-shared --enable-overwrite \
    --without-debug --without-ada --without-manpages \

make -j
make install
