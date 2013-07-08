#!/bin/bash

mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    ..
make VERBOSE=2
make install
