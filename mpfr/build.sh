./configure --prefix=$PREFIX \
    --with-gmp=$PREFIX \
    --disable-shared \
    --enable-static

make
make check
make install
