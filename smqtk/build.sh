#!/bin/bash

mv python/smqtk/web/geospace/parse_istdata.py python/smqtk/web/geospace/parse_istdata.sh

mkdir build
cd build

cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=${PREFIX} -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} ${SRC_DIR}

make -j$CPU_COUNT
make install
