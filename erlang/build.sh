#!/bin/bash

./configure \
    --with-ssl=$PREFIX \
    --prefix=$PREFIX
make
make install
