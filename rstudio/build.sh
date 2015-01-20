mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DRSTUDIO_TARGET=Desktop \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_LIBR_HOME=$PREFIX/lib/R \
      ..

make install
