#!/bin/bash

mkdir -vp ${PREFIX}/bin;

./configure --prefix=${PREFIX} || exit 1;

if [[ $(uname) == 'Darwin' ]]; then
    echo '' > update.log || exit 1;
fi

make || exit 1;
make install || exit 1;

