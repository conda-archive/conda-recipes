#!/bin/bash

# Build dependencies:
# - lapack
# - lapack-devel

touch requirements.txt;

export CFLAGS="-m64 -pipe -O2 -march=x86-64"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib -L${PREFIX}/lib64"

${PYTHON} setup.py install;

mkdir -vp ${PREFIX}/bin;

POST_LINK="${PREFIX}/bin/.cvxopt-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};
