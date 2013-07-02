#!/bin/bash
CC=cc CXX=c++ ./configure --prefix=$PREFIX
make
rm $SRC_DIR/Modules/CPack.OSXScriptLauncher.in
make install
