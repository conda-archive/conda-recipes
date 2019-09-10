mkdir build || exit 1;
cd build || exit 1;

# CMAKE_INSTALL_LIBDIR="lib" suppresses CentOS default of lib64 (conda expects lib)

cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_INSTALL_LIBDIR="lib" \
  -DBUILD_TESTING=OFF \
  -DBUILD_SHARED_LIBS=ON \
  -DLAPACKE=ON \
  ..

make -j${CPU_COUNT}
make install
