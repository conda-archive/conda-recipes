#!/bin/sh

if uname | grep Darwin > /dev/null; then
    # libxml is causing configure to bomb out for me.
    configure --prefix=$PREFIX --with-python --with-openssl
else
    configure --prefix=$PREFIX --with-python --with-openssl --with-libxml --with-libxslt
fi

make
make install
