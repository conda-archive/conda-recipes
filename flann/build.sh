#!/bin/bash

mkdir build
cd build

# Make/Install C/C++ portion
cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
  -DBUILD_C_BINDINGS:BOOL=ON \
  -DBUILD_PYTHON_BINDINGS:BOOL=ON \
  -DBUILD_MATLAB_BINDINGS:BOOL=OFF \
  ${SRC_DIR}

make -j$CPU_COUNT
make install

# Install python components via generated setup.py
cd ${PREFIX}/share/flann/python
${PYTHON} setup.py install --prefix "${PREFIX}"
