#!/bin/bash

set -e

if [[ `uname` == 'Darwin' ]]; then
    DYLIB_EXT=dylib
else
    DYLIB_EXT=so
fi


python setup.py install --prefix=$PREFIX

ln -s $PREFIX/lib/libtiff.$DYLIB_EXT $SP_DIR/libtiff/libtiff.$DYLIB_EXT
