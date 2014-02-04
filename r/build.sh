#!/bin/bash

./configure --enable-R-shlib --with-readline=no --with-tcl-config=$PREFIX/lib/tclConfig.sh --with-tk-config=$PREFIX/lib/tkConfig.sh --prefix=$PREFIX
make
make install
