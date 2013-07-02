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
    -DCMAKE_INSTALL_PREFIX:PATH="$ARTIFACT" \
    -DCMAKE_INSTALL_RPATH:STRING="$ARTIFACT/lib" \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DOSMESA_LIBRARY:FILEPATH=$MESA/lib/libOSMesa.so \
    -DOSMESA_INCLUDE_DIR:PATH=$MESA/include \
    -DOPENGL_INCLUDE_DIR:PATH=$MESA/include \
    -DOPENGL_gl_LIBRARY:FILEPATH=$MESA/lib/libGL.so \
    -DPYTHON_EXECUTABLE:FILEPATH=$PYTHON/bin/python \
    -DPYTHON_INCLUDE_PATH:PATH=$PYTHON/include/python2.7 \
    -DPYTHON_LIBRARY:FILEPATH=$PYTHON/lib/libpython2.7.so \
    -DVTK_USE_X:BOOL=OFF \
    -DVTK_WRAP_PYTHON:BOOL=ON \
    -DVTK_USE_OFFSCREEN:BOOL=ON \
    -DVTK_OPENGL_HAS_OSMESA:BOOL=ON \
    .

make
make install
