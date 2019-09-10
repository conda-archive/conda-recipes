#!/bin/sh

aclocal && \
autoconf && \
autoheader && \
automake --add-missing && \
./configure --prefix=$PREFIX
make -j $CPU_COUNT
make install
