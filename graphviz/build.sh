#!/bin/sh
# see http://conda.pydata.org/docs/build.html for hacking instructions.

export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

if [ `uname` == Darwin ]; then
./configure --prefix=$PREFIX --with-quartz | tee configure.log 2>&1
else
./configure --prefix=$PREFIX | tee configure.log 2>&1
fi
make install | tee make.log 2>&1

# vim: set ai et nu:
