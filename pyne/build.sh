#!/bin/bash

$PYTHON setup.py install

find . -name '*.so' | xargs chmod +x
cp build/cpp/*.so $PREFIX/lib
