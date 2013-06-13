#!/bin/bash

if [ `uname` == Linux ]; then
    CC=gcc44
    CXX=g++44
fi
if [ `uname` == Darwin ]; then
    CC=gcc
    CXX=g++
#    EXTRA="-DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/"
fi

mkdir build
cd build
cmake                                                                      \
    $EXTRA                                                                 \
    -DCMAKE_C_COMPILER=$CC                                                 \
    -DCMAKE_CXX_COMPILER=$CXX                                              \
    -DBUILD_SHARED_LIBS=ON                                                 \
    -DPYTHON_EXECUTABLE:FILEPATH=$PREFIX/bin/python${PY_VER}               \
    -DPYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python${PY_VER}             \
    -DPYTHON_LIBRARY:FILEPATH=$STDLIB_DIR/config/libpython${PY_VER}.a      \
    -DPYTHON_PACKAGES_PATH:PATH=$SP_DIR                                    \
    -DBUILD_PYTHON_SUPPORT=ON                                              \
    -DVTK_WRAP_PYTHON=ON                                                   \
    -DVTK_USE_TK=OFF                                                       \
    -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make
make install
