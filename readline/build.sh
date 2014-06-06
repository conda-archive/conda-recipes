#!/bin/bash

./configure --prefix=$PREFIX
make SHLIB_LIBS="-ltinfo"
make install

rm -rf $PREFIX/share/man
rm -rf $PREFIX/share/readline
