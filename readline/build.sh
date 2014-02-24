#!/bin/bash

./configure --prefix=$PREFIX
make
make install

rm -rf $PREFIX/share/man
rm -rf $PREFIX/share/readline
