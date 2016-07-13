#!/bin/bash

./configure --prefix=${PREFIX} \
            --without-debug --without-ada --without-manpages \
            --with-shared --disable-overwrite --enable-termcap \
            --enable-pc-files --enable-widec --enable-symlinks \
            --with-pkg-config-libdir=${PREFIX}/pc

make -j$(getconf _NPROCESSORS_ONLN)
make install

if [[ $(uname -s) == Linux ]]; then
  _SOEXT=.so
else
  _SOEXT=.dylib
fi

pushd ${PREFIX}/lib
  for _LIB in ncurses ncurses++ form panel menu; do
    if [[ -f lib${_LIB}w${_SOEXT} ]]; then
      ln -s lib${_LIB}w${_SOEXT} lib${_LIB}${_SOEXT}
    fi
    if [[ -f lib${_LIB}w.a ]]; then
      ln -s lib${_LIB}w.a lib${_LIB}.a
    fi
    if [[ -f pkgconfig/${_LIB}w.pc ]]; then
      ln -s ${_LIB}w.pc pkgconfig/${_LIB}.pc
    fi
  done
popd
