#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

DEST="${PWD}"/install-libunwind
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd llvm_build_final/projects/libunwind
  make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  cp -Rf * "${PREFIX}"
popd
