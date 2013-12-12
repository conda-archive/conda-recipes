#!/bin/bash

# Build dependencies:
# - libjpeg-devel
# - libpng-devel
# - libtiff-devel
# - openexr-libs
# - openexr-devel
# - boost
# - boost-devel
# - boost-python

export CFLAGS="-m64 -pipe -O2 -march=x86-64 -I${PREFIX}/include"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="-L${PREFIX}/lib"

export CMAKE_INCLUDE_PATH="${PREFIX}/include"
export CMAKE_LIBRARY_PATH="${PREFIX}/lib"

mkdir -vp ${PREFIX}/bin;

make USE_QT=0 USE_PYTHON=1 USE_OPENGL=0 LINKSTATIC=1 || exit 1;
make install || exit 1;

POST_LINK="${PREFIX}/bin/.openimageio-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};
