#!/bin/sh

export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

autoreconf -i

./configure --prefix=$PREFIX   \
            --with-internal-glib \
            # Compatibility with older automake
            --disable-silent-rules

make
make install
