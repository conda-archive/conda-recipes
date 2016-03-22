#!/bin/bash

mkdir build
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_SHARED_LIBS=True
make
make install
