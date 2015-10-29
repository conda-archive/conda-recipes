mkdir build
cd build

cmake                              \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DBUILD_DEMO=OFF               \
    -DCHOLMOD_INCDIR=/usr/include/suitesparse \
    ..
make
mkdir -p $PREFIX/lib64
cp libsplm.a $PREFIX/lib64/
