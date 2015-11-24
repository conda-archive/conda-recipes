#!/bin/bash

# Hints:
# http://boost.2283326.n4.nabble.com/how-to-build-boost-with-bzip2-in-non-standard-location-td2661155.html
# http://www.gentoo.org/proj/en/base/amd64/howtos/?part=1&chap=3
# http://www.boost.org/doc/libs/1_55_0/doc/html/bbv2/reference.html

# Hints for OSX:
# http://stackoverflow.com/questions/20108407/how-do-i-compile-boost-for-os-x-64b-platforms-with-stdlibc

set -x -e


if [ "$(uname)" == "Darwin" ]; then
    CXXFLAGS="-stdlib=libstdc++"
    LINKFLAGS="-stdlib=libstdc++"

    ./bootstrap.sh \
        --prefix="${PREFIX}" \
        --with-icu="${PREFIX}" \
        2>&1 | tee bootstrap.log

    ./b2 -q \
        variant=release \
        address-model=64 \
        architecture=x86 \
        debug-symbols=off \
        threading=multi \
        link=shared \
        toolset=clang \
        cxxflags="${CXXFLAGS}" \
        linkflags="${LINKFLAGS}" \
        -j ${CPU_COUNT} \
        install 2>&1 | tee b2.log
fi

if [ "$(uname)" == "Linux" ]; then
    echo "using gcc : : /usr/bin/g++44 ; " >> tools/build/src/user-config.jam

    ./bootstrap.sh \
        --prefix="${PREFIX}" \
        --with-icu="${PREFIX}" \
        2>&1 | tee bootstrap.log

    ./b2 -q \
        variant=release \
        address-model="${ARCH}" \
        architecture=x86 \
        debug-symbols=off \
        threading=multi \
        runtime-link=shared \
        link=shared \
        toolset=gcc \
        --layout=system \
        -j ${CPU_COUNT} \
        install 2>&1 | tee b2.log
fi
