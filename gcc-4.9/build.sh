#!/bin/bash

if [[ `uname` == Darwin || `uname -p` == x86_64 ]]; then
    ./configure \
        --prefix=$PREFIX \
        --with-gmp=$PREFIX \
        --with-mpfr=$PREFIX \
        --with-mpc=$PREFIX \
        --with-isl=$PREFIX \
        --with-cloog=$PREFIX \
        --disable-multilib
else
    ./configure \
        --prefix=$PREFIX \
        --with-gmp=$PREFIX \
        --with-mpfr=$PREFIX \
        --with-mpc=$PREFIX \
        --with-isl=$PREFIX \
        --with-cloog=$PREFIX
fi

make
make install
