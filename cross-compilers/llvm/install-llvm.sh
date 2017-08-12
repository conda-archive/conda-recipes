#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

DEST="${PWD}"/install-llvm
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd llvm_build_final
  make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  # Remove bits that are packaged in llvm-lto-tapi
  # (which llvm depends upon)
  rm include/llvm-c/lto.h
  rm lib/libLTO.dylib
  cp -Rf * "${PREFIX}"
popd
