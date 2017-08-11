#!/bin/bash

. activate "${PREFIX}"
cd "${SRC_DIR}"

pushd ${PREFIX}/bin
  ln -s clang clang++
popd
