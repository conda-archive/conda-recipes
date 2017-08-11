#!/bin/bash

DEST=${PWD}/install-clang
pushd llvm_build_final/tools/clang
  make install DESTDIR=${DEST}
popd
pushd ${DEST}/${PWD}/prefix
  cp -Rf * ${PREFIX}
  install -Dm644 LICENSE.TXT "${PREFIX}"/share/licenses/clang/LICENSE
popd
rm -f ${PREFIX}/bin/clang++
