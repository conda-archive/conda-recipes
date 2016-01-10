#!/bin/bash

./configure \
    CC=gcc44 \
    CXX=g++44 \
    CXXFLAGS="-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31" \
    CFLAGS="-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31" \
    --disable-xvmc \
    --disable-glx \
    --disable-dri \
    --with-dri-drivers="" \
    --with-gallium-drivers="swrast" \
    --enable-texture-float \
    --disable-shared-glapi \
    --disable-egl \
    --with-egl-platforms="" \
    --enable-gallium-osmesa \
    --enable-gallium-llvm=yes \
    --prefix=$PREFIX
 
make -j2
make install
