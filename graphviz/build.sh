#!/bin/sh
# see http://conda.pydata.org/docs/build.html for hacking instructions.

./configure --prefix=$PREFIX | tee configure.log 2>&1
make | tee make.log 2>&1
make install | tee install.log 2>&1

# vim: set ai et nu:
