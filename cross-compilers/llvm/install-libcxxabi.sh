#!/bin/bash

DEST=${PWD}/install-libcxxabi
pushd llvm_build_final/projects/libcxxabi
  make install DESTDIR=${DEST}
popd
pushd ${DEST}/${PWD}/prefix
  cp -Rf * ${PREFIX}
popd
