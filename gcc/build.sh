./configure \
    --prefix=$PREFIX \
    --with-gmp=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-mpc=$PREFIX

make
make install
