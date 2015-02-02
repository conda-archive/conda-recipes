if [ "$(uname)" == "Darwin" ]; then
    export LDFLAGS="-Wl,-headerpad_max_install_names"
    export BOOT_LDFLAGS="-Wl,-headerpad_max_install_names"
fi

./configure \
    --prefix=$PREFIX \
    --libdir=$PREFIX/lib \
    --with-gmp=$PREFIX \
    --with-mpfr=$PREFIX \
    --with-mpc=$PREFIX \
    --with-isl=$PREFIX \
    --with-cloog=$PREFIX \
    --with-boot-ldflags=$LDFLAGS \
    --with-stage1-ldflags=$LDFLAGS \
    --disable-multilib

make
make install
