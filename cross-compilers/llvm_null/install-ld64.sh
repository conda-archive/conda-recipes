#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

DEST="${PWD}"/install-ld64
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd cctools_build_final/ld64
  PATH=${SRC_DIR}/prefix/bin:${PATH} make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  cp -Rf * "${PREFIX}"
popd
