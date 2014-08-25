#!/bin/bash

if [[ "$uname" == 'Darwin' ]]; then
    N_CORES=`sysctl -n hw.ncpu`
    make -j $N_CORES
    make install
    
elif if [[ "$unames" == 'Linux' ]]; then
    
    export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
    export CXXLAGS="${CFLAGS}"
    export CPPFLAGS="-I${PREFIX}/include"
    export LDFLAGS="-L${PREFIX}/lib"
    
    cd ${SRC_DIR} || exit 1;
    
    sed -i 's:-o root -g root::' Makefile* || exit 1;
    
    make || exit 1;
    make install DESTDIR="${PREFIX}" || exit 1;
fi
