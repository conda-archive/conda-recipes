#!/bin/bash

mkdir $PREFIX/lib
TERMINFO_DIRS=/etc/terminfo:/lib/terminfo:/usr/share/terminfo:$PREFIX/share/terminfo

sh ./configure --prefix=$PREFIX \
    --without-debug \
    --without-ada \
    --without-manpages \
    --with-shared \
    --disable-overwrite \
    --disable-termcap \
    --with-terminfo-dirs=/etc/terminfo:/lib/terminfo:/usr/share/terminfo:$PREFIX/share/terminfo \
    --with-default-terminfo-dir=/usr/share/terminfo

make -j$(getconf _NPROCESSORS_ONLN)
make install
