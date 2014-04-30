#!/bin/bash
./configure  --without-gsettings --prefix=$PREFIX

make -j4  && make -j4  install
cp $RECIPE_DIR/start_emacs.sh $PREFIX/bin
