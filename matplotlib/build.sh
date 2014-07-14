#!/bin/bash

if [ `uname` == Darwin ]; then
    $REPLACE '#ifdef WITH_NEXT_FRAMEWORK' '#if 1' src/_macosx.m
fi

cp setup.cfg.template setup.cfg || exit 1

$PYTHON setup.py install

rm -rf $SP_DIR/PySide
