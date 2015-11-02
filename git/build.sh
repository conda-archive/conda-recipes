#!/bin/bash

# NOTE: On Ubuntu, compilation required installation of autoconf and gettext from apt-get

make configure
if [ $ARCH == 64 ]; then
    CFLAGS="$CFLAGS -m64" CPPFLAGS="$CPPFLAGS -I$PREFIX/include" LDFLAGS="$LDFLAGS -L$PREFIX/lib" ./configure --prefix=$PREFIX --without-tcltk
else
    CPPFLAGS="$CPPFLAGS -I$PREFIX/include" LDFLAGS="$LDFLAGS -L$PREFIX/lib" ./configure --prefix=$PREFIX --without-tcltk
fi
make all
make install

cd $PREFIX
rm -rf lib lib64
rm -rf share/man
strip bin/* || echo
strip libexec/git-core/* || echo
