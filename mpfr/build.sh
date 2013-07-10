./configure --prefix=$PREFIX \
    --with-gmp=$PREFIX \
    --disable-shared

make
make check
make install
