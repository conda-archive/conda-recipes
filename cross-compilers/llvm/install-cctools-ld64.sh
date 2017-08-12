#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

DEST="${PWD}"/install-cctools-ld64
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd cctools_build_final
  make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  cp -Rf * "${PREFIX}"
popd
