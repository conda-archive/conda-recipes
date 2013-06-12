#!/bin/bash

set -e

if [ `uname` == Linux ]; then
    CC=gcc44
    CXX=g++44
fi
if [ `uname` == Darwin ]; then
    CC=gcc-4.2
    CXX=g++-4.2
    EXTRA="-DCMAKE_OSX_SYSROOT=/Developer/SDKs/MacOSX10.5.sdk"
fi

mkdir build
cd build
cmake                                                                      \
    $EXTRA                                                                 \
    -DCMAKE_C_COMPILER=$CC                                                 \
    -DCMAKE_CXX_COMPILER=$CXX                                              \
    -DJPEG_INCLUDE_DIR:PATH=$PREFIX/include                                \
    -DJPEG_LIBRARY:FILEPATH=$PREFIX/lib/libjpeg.so                         \
    -DPNG_PNG_INCLUDE_DIR:PATH=$PREFIX/include                             \
    -DPNG_LIBRARY:FILEPATH=$PREFIX/lib/libpng.so                           \
    -DZLIB_INCLUDE_DIR:PATH=$PREFIX/include                                \
    -DZLIB_LIBRARY:FILEPATH=$PREFIX/lib/libz.so                            \
    -DPYTHON_EXECUTABLE:FILEPATH=$PREFIX/bin/python${PY_VER}               \
    -DPYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python${PY_VER}             \
    -DPYTHON_LIBRARY:FILEPATH=$STDLIB_DIR/config/libpython${PY_VER}.a      \
    -DPYTHON_PACKAGES_PATH:PATH=$SP_DIR                                    \
    -DCUDA_TOOLKIT_ROOT_DIR=/nowhere                                       \
    -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make
make install

rm -rf $PREFIX/share/OpenCV
