#!/bin/bash

mkdir -vp ${PREFIX}/bin;

#export CXXLAGS="${CFLAGS}"
#export CPPFLAGS="-I${PREFIX}/include"
#export LDFLAGS="-L${PREFIX}/lib"

touch requirements.txt;

${PYTHON} setup.py install || exit 1;

