#!/bin/bash

DEST=${PWD}/install-cctools-ld64
pushd cctools_build_final
  make install DESTDIR=${DEST}
popd
pushd ${DEST}/${PWD}/prefix
  cp -Rf * ${PREFIX}
popd
