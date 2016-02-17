./configure \
    --prefix=$PREFIX \
    --with-gmp=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-mpc=$PREFIX \
    --with-ppl=$PREFIX

make
make install
