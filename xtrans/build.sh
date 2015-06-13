#!/bin/bash

./configure --prefix="$PREFIX"
make
make install

# Move the pkgconfig file to the correct spot
mkdir -p "$LIBRARY_PATH"/pkgconfig
mv "$PREFIX"/share/pkgconfig "$LIBRARY_PATH"
