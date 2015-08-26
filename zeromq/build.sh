#!/bin/bash
# default is 10.5 for some reason, which doesn't work
export MACOSX_DEPLOYMENT_TARGET=10.6
./configure --prefix=$PREFIX --with-libsodium=$PREFIX
make
make install
