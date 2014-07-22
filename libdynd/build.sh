#!/bin/bash

if [[ (`uname` == Linux) && (`uname -m` != armv6l) ]]; then
    CC=gcc44
    CXX=g++44
elif [ `uname` == Darwin ]; then
    CC=gcc-4.2
    CXX=g++-4.2
    EXTRA="-DCMAKE_OSX_SYSROOT=$SDK"
    # to get cmake onto PATH
    PATH=$SYS_PREFIX/bin:$PATH
else
    CC=cc
    CXX=c++
fi

mkdir build
cd build
cmake                                                     \
    $EXTRA                                                \
    -DCMAKE_C_COMPILER=$CC                                \
    -DCMAKE_CXX_COMPILER=$CXX                             \
    -DCMAKE_BUILD_TYPE=Release                            \
    -DDYND_SHARED_LIB=ON                                  \
    -DDYND_INSTALL_LIB=ON                                 \
    -DCMAKE_INSTALL_PREFIX=$PREFIX .. || exit 1
make
make install
