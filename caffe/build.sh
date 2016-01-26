#!/bin/bash

mkdir cmake_build && cd cmake_build
cmake .. -DBUILD_SHARED_LIB=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=${PREFIX}

make -j ${CPU_COUNT} VERBOSE=1 && make install
