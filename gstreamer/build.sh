#!/bin/bash

# gstreamer expects libffi.la to be in lib64 for some reason.
mkdir $PREFIX/lib64
cp -r $LIBRARY_PATH/libffi* $PREFIX/lib64
ls $PREFIX/lib64

# The datarootdir option places the docs into a temp folder that won't
# be included in the package (it is about 12MB).
./configure --disable-examples --prefix="$PREFIX" --datarootdir=`pwd`/tmpshare
make
make install

# Remove the created lib64 directory
rm -rf $PREFIX/lib64
