#!/bin/sh

export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

./configure --prefix=$PREFIX   \
            --with-ssl=$PREFIX \
            --enable-hcache    \
            --enable-imap      \
            --enable-smtp      \
            --with-homespool=.mailbox
make
make install

