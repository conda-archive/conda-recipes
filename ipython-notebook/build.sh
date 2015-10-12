#!/bin/bash

if [[ (`uname` == Darwin) ]]
then
    BIN=$PREFIX/bin

    mkdir $BIN
    cp $RECIPE_DIR/ipython_mac.command $BIN
fi
