#!/bin/bash

$PYTHON setup.py build_ext -I$PREFIX/include/eigen3 install
