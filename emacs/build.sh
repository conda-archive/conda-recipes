#!/bin/bash
if [ `uname` == Darwin ]; then
    ./configure  --prefix=$PREFIX --without-x
else
    ./configure  --prefix=$PREFIX
fi

make -j4  && make -j4  install
