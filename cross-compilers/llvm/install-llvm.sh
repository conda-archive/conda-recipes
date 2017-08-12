#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

DEST="${PWD}"/install-llvm
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd llvm_build_final
  make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  cp -Rf * "${PREFIX}"
  if [[ -e bin/clang ]]; then
    echo "hmm, llvm contains clang"
    exit 1
  fi
popd
