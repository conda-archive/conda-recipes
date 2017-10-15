#!/usr/bin/env bash

export MINGW_PREFIX="/Library/mingw-w64"
export CARCH=${ARCH}
export MINGW_CHOST=$(gcc -dumpmachine)
export srcdir=${SRC_DIR}
export MAKEFLAGS=-j${CPU_COUNT}
. ./PKGBUILD
pushd ${srcdir}/icu
  autoreconf -vfi
popd
build
export pkgdir="${PREFIX}"
export pkgver=58.2
package_icu
rm -rf "${PREFIX}"/Library/dev
rm -rf "${PREFIX}"/Library/etc
