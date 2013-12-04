mkdir build
cd build

export CC=cc
export CXX=c++
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export CFLAGS="-pipe -O2"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
../configure --prefix=$PREFIX --enable-hardcoded-path-in-test
make
make check
make install
