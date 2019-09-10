#!/bin/sh

# The libxml2 include is needed because libxslt includes
# libxml/*.h  which is a subdirectory
export CFLAGS="-I$PREFIX/include -I$PREFIX/include/libxml2"
export LDFLAGS="-L$PREFIX/lib -lxml2 -L$PREFIX/lib -lxslt"
export LDFLAGS_EX="$LDFLAGS -L$PREFIX/lib -lreadline"

if uname | grep Darwin > /dev/null; then
    # The link step is not the problem.  Testing the a.out
    # binary fails because it finds the wrong dynlib. 
    DYLD_LIBRARY_PATH=$PREFIX/lib ./configure --prefix=$PREFIX \
        --disable-debug        \
        --with-readline        \
        --with-python          \
        --with-openssl         \
        --with-libxml2         \
        --with-libxslt
else
    ./configure --prefix=$PREFIX \
        --with-readline        \
        --with-python          \
        --with-openssl         \
        --with-libxml2         \
        --with-libxslt
fi

make
make install
make install-world
