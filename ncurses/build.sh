#!/bin/bash

sh ./configure --prefix=${PREFIX} \
    --without-debug --without-ada --without-manpages \
    --with-shared --disable-overwrite --enable-termcap \
    --enable-pc-files --enable-widec \
    --with-pkg-config-libdir=${PREFIX}/pc

if [[ $(uname -s) == Darwin ]]; then
    export CC=clang
    export CXX=clang++
fi

make -j$(getconf _NPROCESSORS_ONLN)
make install

for _LIB in ncurses ncurses++ form panel menu; do
  echo "INPUT(-l${_LIB}w)" > ${PREFIX}/lib/lib${_LIB}.so
  ln -s ${_LIB}w.pc ${PREFIX}/lib/pkgconfig/${_LIB}.pc
done
