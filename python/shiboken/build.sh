#!/bin/bash

if [ `uname` == Darwin ]; then
    PY_LIB="libpython${PY_VER}m.dylib"
    #export DYLD_LIBRARY_PATH=$PREFIX/lib
else
    if [ "$PY3K" == "1" ]; then
        PY_LIB="libpython${PY_VER}m.so"
    else 
        PY_LIB="libpython${PY_VER}.so"
    fi
fi

mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake-qt4 \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DPYTHON_INCLUDE_DIR="$PREFIX/include/python${PY_VER}" \
    -DPYTHON3_INCLUDE_DIR="$PREFIX/include/python${PY_VER}m" \
    -DPYTHON_LIBRARY=$PREFIX/lib/$PY_LIB \
    -DPYTHON3_LIBRARY=$PREFIX/lib/$PY_LIB \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    -DUSE_PYTHON3=$PY3K \
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
