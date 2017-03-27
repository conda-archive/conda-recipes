#!/bin/bash

if [[ $(uname) == Darwin ]]; then
  export MACOSX_DEPLOYMENT_TARGET=10.9
  # Unfortunately this precludes OpenMP.
  export CC=clang
  export CXX=clang++
fi

pushd ${SRC_DIR}/R-package
  ${R} CMD INSTALL --build .
popd
