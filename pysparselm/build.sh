#!/usr/bin/sh

sed -i -e 's/fpic/fPIC/' setup.py
export CC="gcc -fPIC"
$PYTHON setup.py build build_ext -I$PREFIX/include/splm/ -L$PREFIX/lib64/ -lsplm
$PYTHON setup.py install
