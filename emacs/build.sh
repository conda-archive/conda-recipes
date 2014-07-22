#!/bin/bash
./configure  --prefix=$PREFIX --without-x

make -j4  && make -j4  install
