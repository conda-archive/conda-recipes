#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

DEST="${PWD}"/install-clang
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd llvm_build_final/tools/clang
  make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  cp -Rf * "${PREFIX}"
  rm "${PREFIX}"/bin/clang++
popd
