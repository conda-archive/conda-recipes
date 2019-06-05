#!/usr/bin/env bash

export MINGW_PREFIX="/Library/mingw-w64"
check_option() {
  echo n
}
if [[ ${ARCH} == 32 ]]; then
  export CARCH=i686
else
  export CARCH=x86_64
fi
export MINGW_CHOST=$(gcc -dumpmachine)
export srcdir=${SRC_DIR}
export MAKEFLAGS=-j${CPU_COUNT}
export PKG_CONFIG_PATH=/mingw-w64/lib/pkgconfig:/mingw-w64/share/pkgconfig
export pkgdir="${PREFIX}"
export pkgver=${PKG_VERSION}

. ./PKGBUILD
# Breaks, PKG_CONFIG issues leading to CPPUNIT issues.
# pushd ${srcdir}/JAGS-${PKG_VERSION}
#   autoreconf -vfi
# popd
build || exit 1
package || exit 1
