#!/bin/bash
CC=cc CXX=c++ ./configure --prefix=$PREFIX --parallel=${CPU_COUNT}
make -j${CPU_COUNT}
rm $SRC_DIR/Modules/CPack.OSXScriptLauncher.in
make install
