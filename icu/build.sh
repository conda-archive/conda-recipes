#!/bin/bash

cd source
chmod +x runConfigureICU configure install-sh

if [ "$(uname)" == "Linux" ]; then
    ./runConfigureICU Linux --prefix="$PREFIX"
fi

if [ "$(uname)" == "Darwin" ]; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LDFLAGS="-Wl,-headerpad_max_install_names"

    ./configure --prefix="$PREFIX" \
        --disable-samples \
        --disable-tests \
        --enable-static \
        --with-library-bits=64
fi

make
make install

