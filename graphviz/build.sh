#!/bin/sh
# see http://conda.pydata.org/docs/build.html for hacking instructions.

if [ `uname` == Darwin ]; then
./configure --prefix=$PREFIX \
  --without-qt --with-quartz --enable-static \
  | tee configure.log 2>&1
else
./configure --prefix=$PREFIX | tee configure.log 2>&1
fi
make install | tee make.log 2>&1

# vim: set ai et nu:
