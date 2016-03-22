#!/bin/bash

mkdir build
cd build

export CC=$PREFIX/bin/gcc
export CXX=$PREFIX/bin/g++

cmake \
    -DCMAKE_INSTALL_PREFIX:PATH="$PREFIX" \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_QT4=true \
    -DQTC_QT4_STYLE_SUPPORT=false \
    -DENABLE_QT5=false \
    -DENABLE_GTK2=false \
    -DQTC_ENABLE_X11=false \
    -DQTC_INSTALL_PO=false \
    -DQTC_QT4_ENABLE_KDE=false \
    ..

make
make install
