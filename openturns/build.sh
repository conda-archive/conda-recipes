#!/bin/bash

if [ `uname` == Darwin ]; then
    SO_EXT='dylib'
else
    SO_EXT='so'
fi

mkdir build
cd build

cmake \
    -DLAPACK_LIBRARIES="$PREFIX/lib/libblas.${SO_EXT};$PREFIX/lib/liblapack.${SO_EXT}" \
    -DLIBXML2_LIBRARIES=$PREFIX/lib/libxml2.${SO_EXT} \
    -DLIBXML2_INCLUDE_DIR=$PREFIX/include/libxml2 \
    -DMUPARSER_LIBRARIES=$PREFIX/lib/libmuparser.${SO_EXT} \
    -DMUPARSER_INCLUDE_DIR=$PREFIX/include \
    -DBOOST_ROOT=$PREFIX \
    -DSWIG_EXECUTABLE:FILEPATH=$PREFIX/bin/swig \
    -DPYTHON_EXECUTABLE:FILEPATH=$PREFIX/bin/python${PY_VER} \
    -DPYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python${PY_VER} \
    -DPYTHON_LIBRARY:FILEPATH=$PREFIX/lib/libpython${PY_VER}.${SO_EXT} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DUSE_TBB=OFF \
    -DUSE_SPHINX=OFF \
    ..

make -j$(getconf _NPROCESSORS_ONLN)
make install
