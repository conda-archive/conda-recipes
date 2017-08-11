#!/bin/bash

pushd projects/libcxxabi
  make DESTDIR=${PWD}/install-libcxxabi install
popd

pushd ${PWD}/install-libcxxabi/${PWD}/prefix
  cp -Rf * ${PREFIX}
popd
