#!/bin/bash

VER=$PKG_VERSION

cd $SRC_DIR
tar xzf tcl${VER}-src.tar.gz
tar xzf tk${VER}-src.tar.gz

cd $SRC_DIR/tcl${VER}/unix
./configure --prefix=$PREFIX
make
make install

cd $SRC_DIR/tk${VER}/unix
./configure --with-tcl=$PREFIX/lib --prefix=$PREFIX --enable-aqua=yes
make
make install

cd $PREFIX
rm -rf man share
