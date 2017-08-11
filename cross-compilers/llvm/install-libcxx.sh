#!/bin/bash

DEST=${PWD}/install-libcxx
pushd llvm_build_final/projects/libcxx
  make install DESTDIR=${DEST}
popd
pushd ${DEST}/${PWD}/prefix
  cp -Rf * ${PREFIX}
popd
