#!/bin/bash

if [ `uname` == Linux ]; then
    CC=gcc
    CXX=g++
fi
if [ `uname` == Darwin ]; then
    CC=cc
    CXX=c++
    EXTRA="-DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/"
fi

# Need boost includes >= 1.41.0
if [[ -d $SYS_PREFIX/include/boost ]]; then
    BOOST="-DBoost_NO_BOOST_CMAKE:BOOL=ON -DBoost_INCLUDE_DIR:PATH=$SYS_PREFIX/include -DBoost_LIBRARY_DIRS:FILEPATH=$SYS_PREFIX/lib"
else
    BOOST="-DBoost_DIR=/usr"
fi

mkdir build
cd build
cmake                                                                      \
    $EXTRA                                                                 \
    -DBUILD_TESTING:BOOL=ON                                                \
    -DCMAKE_C_COMPILER=$CC                                                 \
    -DCMAKE_CXX_COMPILER=$CXX                                              \
    -DPYTHON_EXECUTABLE:FILEPATH=$PREFIX/bin/python${PY_VER}               \
    -DPYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python${PY_VER}             \
    -DPYTHON_LIBRARY:FILEPATH=$PREFIX/lib/libpython${PY_VER}.so            \
    $BOOST                                                                 \
    -DXDMF_BUILD_TESTING:BOOL=ON                                           \
    -DXDMF_BUILD_UTILS:BOOL=ON                                             \
    -DXDMF_WRAP_PYTHON:BOOL=ON                                             \
    -DCMAKE_INSTALL_PREFIX=$PREFIX                                         \
    ..
make
#make test
make install

cat > $PREFIX/lib/python/__init__.py << __EOF__

from Xdmf import *
import XdmfCore as Core
import XdmfUtils as Utils

__version__ = "20131030"


__EOF__

mv -v $PREFIX/lib/python $SP_DIR/Xdmf
mv -v $PREFIX/XdmfConfig.cmake $PREFIX/lib/.

