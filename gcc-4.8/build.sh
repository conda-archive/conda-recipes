./configure \
    --prefix=$PREFIX \
    --with-gmp=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-mpc=$PREFIX \
    --with-isl=$PREFIX \
    --with-cloog=$PREFIX \
    --disable-multilib

make
make install

mv $PREFIX/lib64/* $PREFIX/lib/
