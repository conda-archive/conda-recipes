#!/bin/bash

# Build dependencies:
# - portaudio-devel

export CFLAGS="-m64 -pipe -O2 -march=x86-64"
export CXXFLAGS="${CFLAGS}"

mkdir -vp ${PREFIX}/bin;

touch requirements.txt;

${PYTHON} setup.py install || exit 1;

#POST_LINK="${PREFIX}/bin/.pyaudio-post-link.sh"
#cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
#chmod -v 0755 ${POST_LINK};
