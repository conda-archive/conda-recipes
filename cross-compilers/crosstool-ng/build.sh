#!/bin/bash

export EXTRA_CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncurses"
export EXTRA_LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib -lncursesw"
export CPPFLAGS="-I${PREFIX}/include -L${PREFIX}/lib"
if [[ $(uname) == Darwin ]]; then
  export DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib
fi
./bootstrap
./configure --prefix=${PREFIX}
make V=1
make install
