#!/bin/bash

export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

mkdir -p ${PREFIX}/bin;

# Linux dependencies in CentOS:
# - fontconfig-devel

cd ${SRC_DIR} || exit 1;

./build.sh || exit 1;

mv ${SRC_DIR}/bin/phantomjs ${PREFIX}/bin/ || exit 1;

