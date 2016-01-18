#!/usr/bin/env bash

export C_INCLUDE_PATH=$PREFIX/include  # required as fftw3.h installed here
$PYTHON setup.py build
$PYTHON setup.py install --optimize=1
