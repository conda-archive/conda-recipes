#!/bin/bash

# http://xgboost.readthedocs.io/en/latest/build.html
# We need GCC 6 or clang >= 3.7 for -fopenmp support on macOS.
if [[ $(uname) == Darwin ]]; then
  cp make/minimum.mk ./config.mk
  export MACOSX_DEPLOYMENT_TARGET=10.9
  export CC=gcc
  export CXX=g++
  BUILD_NCPUS=$(sysctl -n hw.ncpu)
elif [[ ${OSTYPE} == msys ]]; then
  if [[ "${ARCH}" == "32" ]]; then
    # SSE2 is used and we get called from MSVC
    # CPython so 32-bit GCC needs realignment.
    export CC="gcc -mstackrealign"
    export CXX="g++ -mstackrealign"
  fi
  cp make/mingw64.mk ./config.mk
  BUILD_NCPUS=${NUMBER_OF_PROCESSORS}
else
  cp make/config.mk ./config.mk
  BUILD_NCPUS=$(grep -c ^processor /proc/cpuinfo)
fi
make -j${BUILD_NCPUS}
