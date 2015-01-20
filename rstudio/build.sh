mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DRSTUDIO_TARGET=Server \
      -DCMAKE_BUILD_TYPE=Release \
      ..

make install
