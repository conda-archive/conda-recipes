#!/bin/bash

chmod +x configure

./configure --prefix $PREFIX --enable-libxml2 --disable-docs

make
make install

# Remove computed cache with local fonts
rm -Rf $PREFIX/var/cache/fontconfig

# Leave cache directory, in case it's needed
mkdir -p $PREFIX/var/cache/fontconfig
touch $PREFIX/var/cache/fontconfig/.leave
