#!/bin/bash

chmod +x configure

./configure --prefix=$PREFIX   \
            --with-sysroot=$PREFIX    \
            --enable-shared   \
            --enable-cxx

make
make check 2>&1 | tee gmp-check-log
awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log
make install

