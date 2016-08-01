#!/bin/sh

LIBFFI_LIBS="-L$PREFIX/lib -lffi" ./configure --prefix="$PREFIX" LIBFFI_LIBS="-L$PREFIX/lib -lffi"
make
make install
