#!/bin/sh

mkdir build || exit 1;
cd build || exit 1;

cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DBUILD_SHARED_LIBS:BOOL="1" \
    -DBUILD_STATIC_LIBS:BOOL="0" \
    -DEXAMPLES_ENABLE:BOOL="0" \
    -DEXAMPLES_INSTALL:BOOL="0" \
    -DLAPACK_ENABLE:BOOL="1" \
    -DOPENMP_ENABLE:BOOL="0" \
    .. || exit 1;

make install || exit 1;
