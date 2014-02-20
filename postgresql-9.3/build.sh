#!/bin/sh

export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib -lxml2 -L$PREFIX/lib -lxslt"
export LDFLAGS_EX="$LDFLAGS -L$PREFIX/lib -lreadline"

if uname | grep Darwin > /dev/null; then
    # 10.9 appears to have an issue with libxml2; clang/ld isn't respecting
    # the flags above, and it attempts to link with /usr/lib/libxml2.2.dynlib,
    # which results in an error and ./configure time.  @Aaron, have you seen
    # this before?  Can you reproduce the error?
    configure --prefix=$PREFIX \
        --with-readline        \
        --with-python          \
        --with-openssl         \
        --with-libxml          \
        --with-libxslt
else
    configure --prefix=$PREFIX \
        --with-readline        \
        --with-python          \
        --with-openssl         \
        --with-libxml          \
        --with-libxslt
fi

make
make install
make install-world
