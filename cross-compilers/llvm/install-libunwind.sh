#!/bin/bash

pushd projects/libunwind
  make DESTDIR=${PWD}/install-libunwind install
popd

pushd ${PWD}/install-libunwind/${PWD}/prefix
  cp -Rf * ${PREFIX}
popd
