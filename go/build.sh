#!/bin/bash

# Move the go directory into $PREFIX/ so it can be built in its install location.
cd .. && mv go $PREFIX/ && cd $PREFIX/go

# Change to `src` build and then move out.
cd src
./all.bash
cd ..

# Link binaries.
mkdir -p $PREFIX/bin
ln -s $PREFIX/go/bin/go $PREFIX/bin/go
ln -s $PREFIX/go/bin/gofmt $PREFIX/bin/gofmt
