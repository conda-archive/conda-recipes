mkdir build
cd build

cmake                              \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DBUILD_DEMO=OFF               \
    -DCHOLMOD_INCDIR=/usr/include/suitesparse \
    -DCMAKE_C_FLAGS="-fPIC" \
    ..
make
mkdir -p $PREFIX/lib64
mkdir -p $PREFIX/include/splm
cp libsplm.a $PREFIX/lib64/
cp ../*.h $PREFIX/include/splm/
