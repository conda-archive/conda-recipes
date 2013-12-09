#!/bin/bash

# Build dependencies:
# - OpenEXR-libs
# - OpenEXR-devel

export CFLAGS="-m64 -pipe -O2 -march=x86-64"
export CXXFLAGS="${CFLAGS}"

touch requirements.txt;

mkdir -vp ${PREFIX}/bin;

${PYTHON} setup.py install || exit 1;

POST_LINK="${PREFIX}/bin/.openexr-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};
