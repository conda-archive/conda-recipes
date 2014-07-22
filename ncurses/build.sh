#!/bin/bash

sh ./configure --prefix=$PREFIX \
    --with-shared --enable-overwrite \
    --without-debug --without-ada --without-manpages \
    --with-termlib=tinfo --enable-widec

make -j$(getconf _NPROCESSORS_ONLN)
make install
