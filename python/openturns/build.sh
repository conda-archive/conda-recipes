#!/bin/bash

if [ `uname` == Darwin ]; then
    SO_EXT='.dylib'
else
    SO_EXT='.so'
fi

# handle suffix: python2.7 or python3.5m
PY_LIB=`find $PREFIX/lib -name libpython${PY_VER}*${SO_EXT}`
PY_INC=`find $PREFIX/include -name python${PY_VER}*`

# package must be relocatable
sed -i "48iimport os" python/src/__init__.py
sed -i "49ios.environ['OPENTURNS_CONFIG_PATH'] = os.path.realpath(__file__ + '/../../../../../etc/openturns')" python/src/__init__.py

mkdir -p build && cd build

cmake \
  -DLAPACK_LIBRARIES="$PREFIX/lib/libblas${SO_EXT};$PREFIX/lib/liblapack${SO_EXT}" \
  -DLIBXML2_LIBRARIES=$PREFIX/lib/libxml2${SO_EXT} \
  -DLIBXML2_INCLUDE_DIR=$PREFIX/include/libxml2 \
  -DMUPARSER_LIBRARIES=$PREFIX/lib/libmuparser${SO_EXT} \
  -DMUPARSER_INCLUDE_DIR=$PREFIX/include \
  -DNLOPT_LIBRARY=$PREFIX/lib/libnlopt${SO_EXT} \
  -DNLOPT_INCLUDE_DIR=$PREFIX/lib/include \
  -DBOOST_ROOT=$PREFIX \
  -DTBB_LIBRARY=$PREFIX/lib/libtbb${SO_EXT} \
  -DTBB_INCLUDE_DIR=$PREFIX/include/tbb \
  -DSWIG_EXECUTABLE=$PREFIX/bin/swig \
  -DPYTHON_EXECUTABLE=$PREFIX/bin/python${PY_VER} \
  -DPYTHON_INCLUDE_PATH=$PY_INC \
  -DPYTHON_LIBRARY=$PY_LIB \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DUSE_SPHINX=OFF \
  -DUSE_HMAT=OFF \
  -DUSE_R=OFF \
  ..

make OT -j${CPU_COUNT}
make -j2 # memory hungry swig modules
make install
