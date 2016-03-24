mkdir build || exit 1;
cd build || exit 1;

cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DBUILD_TESTING=OFF \
  -DBUILD_SHARED_LIBS=ON \
  -DLAPACKE=ON \
  ..

make -j${CPU_COUNT}
make install
