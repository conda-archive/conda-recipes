#!/bin/bash

make configure
CFLAGS="$CFLAGS -m64" CPPFLAGS="$CPPFLAGS -I$PREFIX/include" LDFLAGS="$LDFLAGS -L$PREFIX/lib" ./configure --prefix=$PREFIX --without-tcltk
make all
make install

cd $PREFIX
rm -rf lib lib64
rm -rf share/man
strip bin/* || echo
strip libexec/git-core/* || echo
