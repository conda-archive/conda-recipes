#!/bin/bash

$PYTHON setup.py install

rm -rf $SP_DIR/distribute-*-py*.egg/EGG-INFO
mv $SRC_DIR/distribute.egg-info $SP_DIR
