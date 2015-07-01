#!/bin/bash

export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

cd ${SRC_DIR} || exit 1;

LANG="C" sed -i.bak 's:-o root -g root::' Makefile* || exit 1;
cp ${RECIPE_DIR}/Makefile.osx Makefile.osx

make || exit 1;
make install PREFIX="${PREFIX}" DESTDIR="${PREFIX}" || exit 1;

mkdir -p ${PREFIX}/lib || exit 1;
mkdir -p ${PREFIX}/include || exit 1;

mv ${PREFIX}/usr/lib/* ${PREFIX}/lib || exit 1;
mv ${PREFIX}/usr/include/* ${PREFIX}/include || exit 1;

rm -rf ${PREFIX}/usr/ || exit 1;
