#!/usr/bin/env sh

if [[ "$(uname)" == "Darwin" ]]; then
  # CC=clang otherwise:
  # ImportError: dlopen(.../envs/_test/lib/python3.5/site-packages/_nlopt.so, 2): Symbol not found: ___emutls_get_address
  export CC=clang
fi

./configure          \
  --prefix=${PREFIX} \
  --enable-shared    \
  --without-octave   \
  --without-matlab   \
  --without-guile

make -j${CPU_COUNT}

make install
