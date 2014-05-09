#!/usr/bin/env bash

CONFIGURE="./configure --prefix=$PREFIX --enable-shared --enable-threads --disable-fortran"

# Single precision (fftw libraries have "f" suffix)
$CONFIGURE --enable-float --enable-sse
make
make install

# Long double precision (fftw libraries have "l" suffix)
$CONFIGURE --enable-long-double
make
make install

# Double precision (fftw libraries have no precision suffix)
$CONFIGURE --enable-sse2
make
make install

# Test suite
cd tests && make check-local
