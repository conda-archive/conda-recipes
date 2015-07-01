#!/bin/bash

export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

cd ${SRC_DIR} || exit 1;

LANG="C" sed -i.bak 's:-o root -g root::' Makefile* || exit 1;
LANG="C" sed -i.bak 's/-arch ppc//g' Makefile.osx || exit 1;
LANG="C" sed -i.bak 's/MacOSX10.5.sdk/MacOSX10.9.sdk/g' Makefile.osx || exit 1;
LANG="C" sed -i.bak 's/\/Developer\/SDKs/\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/MacOSX.platform\/Developer\/SDKs/g' Makefile.osx || exit 1;
LANG="C" sed -i.bak 's/gcc-4.0/gcc -I\/usr\/include -L\/usr\/lib/g' Makefile.osx || exit 1;
LANG="C" sed -i.bak 's/g++-4.0/g++ -I\/usr\/include -L\/usr\/lib/g' Makefile.osx || exit 1;
LANG="C" sed -i.bak 's/COMPILERFLAGS = /COMPILERFLAGS = -D__ANSI__ /g' Makefile.osx || exit 1;

make || exit 1;
make install DESTDIR="${PREFIX}" || exit 1;

mkdir -p ${PREFIX}/lib || exit 1;
mkdir -p ${PREFIX}/include || exit 1;

mv ${PREFIX}/usr/lib/* ${PREFIX}/lib || exit 1;
mv ${PREFIX}/usr/include/* ${PREFIX}/include || exit 1;

rm -rf ${PREFIX}/usr/ || exit 1;
