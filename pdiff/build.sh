#!/bin/bash

export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

cd ${SRC_DIR} || exit 1;

sed -i "s:\(/usr/local/include\):\1\n${PREFIX}/usr/include:" CMakeLists.txt || exit 1;
sed -i "s:\(/usr/local/lib\):\1\n${PREFIX}/usr/lib:" CMakeLists.txt || exit 1;

cmake . || exit 1;
make install DESTDIR="${PREFIX}" || exit 1;

mv perceptualdiff ${PREFIX}/bin/ || exit 1;

chrpath -r "\$ORIGIN/../usr/lib" ${PREFIX}/bin/perceptualdiff || exit 1;

pushd ${PREFIX}/bin || exit 1;
ln -vs perceptualdiff pdiff || exit 1;
popd;
