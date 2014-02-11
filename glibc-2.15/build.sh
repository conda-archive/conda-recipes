mkdir build
cd build
# http://askubuntu.com/q/164087/19441
export CFLAGS=-U_FORTIFY_SOURCE
../configure --prefix=$PREFIX
make
make install
