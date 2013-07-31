export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export CFLAGS="-m64 -pipe -O2 -march=core2"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
./configure --prefix=$PREFIX --without-p11-kit
make
make install
