mkdir build
cd build

export CC=gcc
export CFLAGS="-pipe -O2"
export LDFLAGS="-L$PREFIX/lib"
../configure --prefix=$PREFIX --enable-hardcoded-path-in-test --enable-kernel-version=2.6.32
make -j 2
make check
make install
