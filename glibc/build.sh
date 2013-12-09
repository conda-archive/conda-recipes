mkdir build
cd build

export CC=gcc
../configure --prefix=$PREFIX --enable-kernel-version=2.6.32
make -j 2
make check
make install
