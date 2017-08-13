#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

DEST="${PWD}"/install-cctools
[[ -d "${DEST}" ]] && rm -rf "${DEST}"
pushd cctools_build_final
  PATH=${SRC_DIR}/prefix/bin:${PATH} make install DESTDIR="${DEST}"
popd
pushd "${DEST}"/"${PWD}"/prefix
  # This is packaged in ld64
  rm bin/*-ld
  cp -Rf * "${PREFIX}"
popd
