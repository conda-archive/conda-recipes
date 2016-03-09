#!/bin/sh

mkdir build-fmil || exit 1;
pushd build-fmil || exit 1;

cmake -DFMILIB_INSTALL_PREFIX=${PREFIX} ../ || exit 1;
make install test || exit 1;

