mkdir build
cd build
../configure --prefix=$PREFIX
make
make test
make install
