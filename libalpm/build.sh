#!/usr/bin/env bash

./configure --prefix=${PREFIX} CPPFLAGS="-DDEBUG" CFLAGS="-O0 -g"
# Because we patch configure{,.ac} due to OS X being stuck on bash 3:
# .. : 'Prerequisite `configure.ac' is newer than target `aclocal.m4'.
# and: 'aclocal-1.15: command not found' (we've only got 1.14 at present).
touch aclocal.m4 Makefile.in
make -j"${CPU_COUNT}"
make install
