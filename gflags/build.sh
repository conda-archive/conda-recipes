#!/bin/bash

mkdir build
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DBUILD_SHARED_LIBS=ON \
      -DINSTALL_HEADERS=ON

make
make install
