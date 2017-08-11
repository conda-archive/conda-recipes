#!/bin/bash

pushd projects/libcxx
  make DESTDIR=${PWD}/install-libcxx install
popd

pushd ${PWD}/install-libcxx/${PWD}/prefix
  cp -Rf * ${PREFIX}
popd
