#!/bin/bash

chmod +x autogen.sh
./autogen.sh
./configure --prefix=$PREFIX --sysconfdir=$PREFIX/etc --libexecdir=$PREFIX/lib --localstatedir=$PREFIX/var --without-x --enable-link-time-optimization
make -j bootstrap
make install
