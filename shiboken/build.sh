#!/bin/bash

if [ `uname` == Darwin ]; then
    PY_LIB="libpython${PY_VER}m.dylib"
    #export DYLD_LIBRARY_PATH=$PREFIX/lib
else
    PY_LIB="libpython${PY_VER}.so"
fi

mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DPYTHON_INCLUDE_DIR="$PREFIX/include/python${PY_VER}" \
    -DPYTHON_LIBRARY=$PREFIX/lib/$PY_LIB \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    ..
make VERBOSE=2
make install

# mkdir build
# cd build
# cmake \
#     -DCMAKE_INSTALL_PREFIX=$PREFIX \
#     -DCMAKE_BUILD_TYPE=Release \
#     -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
#     -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
#     -DPYTHON_EXECUTABLE=$PYTHON \
#     -DLIB_INSTALL_DIR=$PREFIX/lib \
#     ..
# make VERBOSE=2
# make install
