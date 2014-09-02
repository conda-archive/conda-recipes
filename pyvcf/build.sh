#!/bin/bash

mkdir -vp ${PREFIX}/bin;

#export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
#export CXXLAGS="${CFLAGS}"
#export CPPFLAGS="-I${PREFIX}/include"
#export LDFLAGS="-L${PREFIX}/lib"

touch requirements.txt;

${PYTHON} setup.py install || exit 1;

