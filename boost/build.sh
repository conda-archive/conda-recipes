#!/bin/bash

# Build dependencies:
# - bzip2-devel

export CFLAGS="-m64 -pipe -O2 -march=x86-64"
export CXXFLAGS="${CFLAGS}"

mkdir -vp ${PREFIX}/bin;

./bootstrap.sh --prefix="${PREFIX}/";
./b2 install;

POST_LINK="${PREFIX}/bin/.boost-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};
