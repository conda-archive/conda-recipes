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
  mkdir -p "${PREFIX}"/share/llvm/cmake/{modules,platforms}
  cp -Rf "${SRC_DIR}"/cmake/modules/*.cmake "${PREFIX}"/share/llvm/cmake/modules/
  cp -Rf "${SRC_DIR}"/cmake/platforms/*.cmake "${PREFIX}"/share/llvm/cmake/platforms/
popd
