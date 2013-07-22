#!/bin/bash

if [ `uname` == Linux ]; then
    CC=gcc44
    CXX=g++44
fi
if [ `uname` == Darwin ]; then
    CC=cc
    CXX=c++
    EXTRA="-DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/"
fi

mkdir build
cd build
cmake                                                                       \
    -j 8 \
    $EXTRA                                                                 \
    -DCMAKE_INSTALL_PREFIX:PATH="$PREFIX" \
    -DCMAKE_INSTALL_RPATH:STRING="$PREFIX/lib" \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DPYTHON_EXECUTABLE:FILEPATH=$PYTHON \
    -DPYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python2.7 \
    -DPYTHON_LIBRARY:FILEPATH=$PREFIX/lib/libpython2.7.dylib \
    -DVTK_USE_X:BOOL=OFF \
    -DVTK_WRAP_PYTHON:BOOL=OFF \
    -DVTK_USE_OFFSCREEN:BOOL=ON \
    ..

make
make install
