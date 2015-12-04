#!/bin/bash

# Hints:
# http://boost.2283326.n4.nabble.com/how-to-build-boost-with-bzip2-in-non-standard-location-td2661155.html
# http://www.gentoo.org/proj/en/base/amd64/howtos/?part=1&chap=3
# http://www.boost.org/doc/libs/1_55_0/doc/html/bbv2/reference.html

# Hints for OSX:
# http://stackoverflow.com/questions/20108407/how-do-i-compile-boost-for-os-x-64b-platforms-with-stdlibc

set -x -e
set -o pipefail

case `uname` in
    Darwin)
        b2_options=( toolset=clang )
        ;;
    Linux)
        b2_options=(
            toolset=gcc
            linkflags="'-Wl,-rpath,\$ORIGIN'"
            )
        ;;
esac

./bootstrap.sh \
    --prefix="${PREFIX}" \
    --with-icu="${PREFIX}" \
    2>&1 | tee bootstrap.log

./b2 -q -j ${CPU_COUNT} \
    variant=release \
    address-model=${ARCH} \
    architecture=x86 \
    threading=multi \
    link=shared \
    "${b2_options[@]}" \
    install 2>&1 | tee b2.log
