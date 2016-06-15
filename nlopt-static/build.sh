#!/bin/sh

./configure          \
  --prefix=${PREFIX} \
  --enable-static    \
  --disable-shared   \
  --with-cxx         \
  --without-octave   \
  --without-matlab   \
  --without-guile    \
  --without-python

make
make install
