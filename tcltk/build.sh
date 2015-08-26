#!/bin/bash

VER=$PKG_VERSION

curl "http://superb-dca2.dl.sourceforge.net/project/tcl/Tcl/${VER}/tcl${VER}-src.tar.gz" > tcl${VER}-src.tar.gz
curl "http://superb-dca2.dl.sourceforge.net/project/tcl/Tcl/${VER}/tk${VER}-src.tar.gz" > tk${VER}-src.tar.gz

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
