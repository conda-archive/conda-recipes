#!/bin/bash

export TIFF_ROOT=$PREFIX
export JPEG_ROOT=$PREFIX
export ZLIB_ROOT=$PREFIX
export FREETYPE2_ROOT=$PREFIX

$PYTHON setup.py install

rm -rf $PREFIX/bin
rm -rf $SP_DIR/__pycache__
