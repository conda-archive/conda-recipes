#!/bin/bash
chmod +x configure
export FREETYPE_LIBS=-L$PREFIX/lib/
export FREETYPE_CFLAGS=-I$PREFIX/include/freetype2
export LIBS=-L$PREFIX/lib/
export CFLAGS=-I$PREFIX/include
export LIBXML2_CFLAGS=-I$PREFIX/include/libxml2
export LIBXML2_LIBS=-L$PREFIX/lib/
./configure --prefix $PREFIX --enable-libxml2
make
make install
