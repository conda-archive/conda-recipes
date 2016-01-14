#!/bin/bash -eu

./configure \
    --prefix=$PREFIX --enable-shared --disable-static --with-ldap
make
make install
