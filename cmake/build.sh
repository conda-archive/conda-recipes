#!/bin/bash
CC=cc CXX=c++ ./configure --prefix=$PREFIX
make -j${CPU_COUNT}
rm $SRC_DIR/Modules/CPack.OSXScriptLauncher.in
make install
