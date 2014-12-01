#!/bin/bash

if [ `uname` == Darwin ]; then
    SO_EXT='dylib'
else
    SO_EXT='so'
fi

mkdir build
cd build

cmake \
    -DLIBXML2_LIBRARIES=$PREFIX/lib/libxml2.${SO_EXT} \
    -DLIBXML2_INCLUDE_DIR=$PREFIX/include/libxml2 \
    -DSWIG_EXECUTABLE:FILEPATH=$PREFIX/bin/swig \
    -DPYTHON_EXECUTABLE:FILEPATH=$PREFIX/bin/python${PY_VER} \
    -DPYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python${PY_VER} \
    -DPYTHON_LIBRARY:FILEPATH=$PREFIX/lib/libpython${PY_VER}.${SO_EXT} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX/ \
    ..
make
make install
