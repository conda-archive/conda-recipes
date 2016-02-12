#!/bin/sh

if test `uname` = "Darwin"
then
  SO_EXT='.dylib'
else
  SO_EXT='.so'
fi

# handle suffix: python2.7 or python3.5m
PY_LIB=`find $PREFIX/lib -name libpython${PY_VER}*${SO_EXT}`
PY_INC=`find $PREFIX/include -name python${PY_VER}*`

mkdir -p build && cd build

cmake \
  -DSWIG_EXECUTABLE=$PREFIX/bin/swig \
  -DPYTHON_EXECUTABLE=$PREFIX/bin/python${PY_VER} \
  -DPYTHON_INCLUDE_PATH=$PY_INC \
  -DPYTHON_LIBRARY=$PY_LIB \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DBUILD_DOC=OFF \
  ..

make install -j${CPU_COUNT}
ctest -R pyinstallcheck -j${CPU_COUNT} --output-on-failure

