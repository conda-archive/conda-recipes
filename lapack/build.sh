mkdir build
cd build

cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DBUILD_TESTING=OFF \
    -DBUILD_SHARED_LIBS=ON \
    ..

make -j$(getconf _NPROCESSORS_ONLN)
make install
