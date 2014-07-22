#!/bin/sh

export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

if uname | grep Darwin > /dev/null; then
    with_keyring="--with-macosx-keyring"
elif uname | grep Linux > /dev/null; then
    with_keyring="--with-gnome-keyring"
else
    with_keyring=""
fi

autoreconf -i

./configure --prefix=$PREFIX   \
            --with-ssl=openssl \
            --without-gnutls   \
            $with_keyring

make
make install
