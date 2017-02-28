#!/bin/bash

export EXTRA_CFLAGS="-I${PREFIX}/include"
export EXTRA_LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib -lncursesw"
if [[ $(uname) == Darwin ]]; then
  export DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib
fi
./bootstrap
./configure --prefix=${PREFIX}
make
make install
