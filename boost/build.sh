#!/bin/bash

# Hints:
# http://boost.2283326.n4.nabble.com/how-to-build-boost-with-bzip2-in-non-standard-location-td2661155.html
# http://www.gentoo.org/proj/en/base/amd64/howtos/?part=1&chap=3

# Build dependencies:
# - bzip2-devel

export CFLAGS="-m64 -pipe -O2 -march=x86-64 -fPIC -shared"
export CXXFLAGS="${CFLAGS}"

mkdir -vp ${PREFIX}/bin;

./bootstrap.sh --prefix="${PREFIX}/";
./b2 install;

#POST_LINK="${PREFIX}/bin/.boost-post-link.sh"
#cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
#chmod -v 0755 ${POST_LINK};
