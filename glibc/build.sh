mkdir build
cd build
../configure --prefix=$PREFIX
make
make tests
make install
