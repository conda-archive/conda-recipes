#!/bin/bash

if [ `uname -m` == ppc64le ]; then
    B="--build=ppc64le-linux"
fi

./configure $B --prefix=$PREFIX --with-curses
make
make install

rm -rf $PREFIX/share/man
rm -rf $PREFIX/share/readline
