#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

DEST="${PWD}"/install-compiler-rt
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd llvm_build_final/projects/compiler-rt
  make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  cp -Rf * "${PREFIX}"
popd
