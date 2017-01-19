#!/bin/bash

if [[ $(uname) == Darwin ]]; then
    EXTRA_ARGS="--without-threads"
fi

# Although lxml is recommended over libxml2, gtk-doc needs the
# libxml2 python module and it has been asked for it on github.
./configure ${EXTRA_ARGS} --prefix=${PREFIX} --with-python --with-iconv=${PREFIX} --without-lzma
make
make install
rm -rf ${PREFIX}/share/doc/libxml2-python-*
