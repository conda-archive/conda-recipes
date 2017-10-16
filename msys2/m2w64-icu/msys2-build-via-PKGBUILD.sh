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
if [[ $? != 0 ]]; then
  exit 1
fi
export pkgdir="${PREFIX}"
export pkgver=58.2
package_icu
if [[ $? != 0 ]]; then
  exit 1
fi
rm -rf "${PREFIX}"/Library/dev
rm -rf "${PREFIX}"/Library/etc
