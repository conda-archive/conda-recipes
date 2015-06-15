#!/bin/bash

# Tell go where it will be installed is not the same as where it is being built.
export GOROOT_FINAL=$PREFIX

# Change to `src` build and then move out.
cd src
./all.bash
cd ..

# Install everything manually.
# Note go expects to find `src` for some operations so it **must** be installed.
test -d bin && mkdir -p $PREFIX/bin && mv bin/* $PREFIX/bin
test -d include && mkdir -p $PREFIX/include && mv include/* $PREFIX/include
test -d lib && mkdir -p $PREFIX/lib && mv lib/* $PREFIX/lib
test -d pkg && mkdir -p $PREFIX/pkg && mv pkg/* $PREFIX/pkg
test -d sbin && mkdir -p $PREFIX/sbin && mv sbin/* $PREFIX/sbin
test -d slib && mkdir -p $PREFIX/slib && mv slib/* $PREFIX/slib
test -d src && mkdir -p $PREFIX/src && mv src/* $PREFIX/src
rm -rf $PREFIX/doc/go && mkdir -p $PREFIX/doc/go && mv doc/* $PREFIX/doc/go
