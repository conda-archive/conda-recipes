#!/bin/bash

export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

cd ${SRC_DIR} || exit 1;

sed -i 's:-o root -g root::' Makefile* || exit 1;

make || exit 1;
make install DESTDIR="${PREFIX}" || exit 1;

mkdir -p ${PREFIX}/lib || exit 1;
mkdir -p ${PREFIX}/include || exit 1;

mv ${PREFIX}/usr/lib/* ${PREFIX}/lib || exit 1;
mv ${PREFIX}/usr/include/* ${PREFIX}/include || exit 1;

rm -rf ${PREFIX}/usr/ || exit 1;
