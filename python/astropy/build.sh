#!/bin/bash

$PYTHON setup.py install

rm scripts/README.rst
cp scripts/* $PREFIX/bin
