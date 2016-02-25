#!/bin/bash

#export PATH="$SYS_PREFIX/bin:$PATH"

if [ `uname` == Linux ]; then
    CC="$SYS_PREFIX/bin/gcc"
    CXX="$SYS_PREFIX/bin/g++"
    CMAKE=cmake
    PY_LIB="libpython2.7.so"
fi
if [ `uname` == Darwin ]; then
    CC=cc
    CXX=c++
    CMAKE=$SYS_PREFIX/bin/cmake
    PY_LIB="libpython2.7.dylib"
    export DYLD_LIBRARY_PATH=$PREFIX/lib
fi

mkdir build
cd build
$CMAKE \
    -DCMAKE_INSTALL_PREFIX:PATH="$PREFIX" \
    -DBUILD_PYGMO:BOOL=ON \
    -DPYGMO_PYTHON_VERSION:STRING=2.7.8 \
    -DPYTHON_EXECUTABLE:FILEPATH=$PYTHON \
    -DPYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python2.7 \
    -DPYTHON_LIBRARY:FILEPATH=$PREFIX/lib/$PY_LIB \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON \
    ..

make
make install
