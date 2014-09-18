#!/bin/bash

./configure --prefix=$PREFIX \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --with-features=huge

make VIMRUNTIMEDIR=AAAAA
make install
