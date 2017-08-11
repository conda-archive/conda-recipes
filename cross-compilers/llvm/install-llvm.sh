#!/bin/bash


DEST=${PWD}/install-llvm
pushd llvm_build_final
  make install DESTDIR=${DEST}
popd
pushd ${DEST}/${PWD}/prefix
  cp -Rf * ${PREFIX}
  install -Dm644 LICENSE.TXT "${PREFIX}"/share/licenses/llvm/LICENSE
  # Install CMake stuff
  install -d "${PREFIX}"/share/llvm/cmake/{modules,platforms}
  install -Dm644 "${SRC_DIR}"/cmake/modules/*.cmake "${PREFIX}"/share/llvm/cmake/modules/
  install -Dm644 "${SRC_DIR}"/cmake/platforms/*.cmake "${PREFIX}"/share/llvm/cmake/platforms/
popd
