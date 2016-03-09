#!/bin/bash -eu

CFLAGS="-I$PREFIX/include -I$PREFIX/include/sasl" $PYTHON setup.py install
