#!/bin/bash

if [ `uname` == Darwin ]; then
    export CFLAGS="-arch x86_64"
    export FFLAGS="-static -ff2c -arch x86_64"
    export LDFLAGS="-Wall -undefined dynamic_lookup -bundle -arch x86_64"
    cp $PREFIX/lib/libgfortran*.*a .
    cp $PREFIX/lib/libgcc_s* .
    cp $PREFIX/lib/libquadmath* .
    export LDFLAGS="-Wl,-search_paths_first -L$(pwd) $LDFLAGS"
fi

$PYTHON setup.py build
$PYTHON setup.py install
