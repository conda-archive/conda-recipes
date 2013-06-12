#!/bin/bash

./configure --prefix=$PREFIX
make
rm $SRC_DIR/Modules/CPack.OSXScriptLauncher.in
make install
