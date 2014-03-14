#!/bin/bash

# Build dependencies:
# - samtools-libs
# - samtools-devel

export CFLAGS="-m64 -pipe -O2 -march=x86-64"
export CXXFLAGS="${CFLAGS}"

mkdir -vp ${PREFIX}/bin;

touch requirements.txt;

${PYTHON} setup.py install || exit 1;

#POST_LINK="${PREFIX}/bin/.pysam-post-link.sh"
#cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
#chmod -v 0755 ${POST_LINK};
