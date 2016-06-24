#!/usr/bin/env bash

# Building libarchive 3.1.2 with CMake 3.3.1 doesn't get you .pc files.
# cmake "-DCMAKE_BUILD_TYPE=Release" \
#       "-GUnix Makefiles" \
#       "-DCMAKE_INSTALL_PREFIX=${PREFIX}"
# cmake --build . -- "-j${CPU_COUNT}"
# cmake --build . --target install

autoreconf -i
./configure --prefix=${PREFIX} \
            --with-expat \
            --without-xml2

make -j"${CPU_COUNT}" V=1
make install
