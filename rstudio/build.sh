mkdir build
cd build

export LIBR_HOME=$PREFIX/lib/R
export BOOST_ROOT=$PREFIX
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DRSTUDIO_TARGET=Desktop \
      -DCMAKE_BUILD_TYPE=Release \
      ..

make install
