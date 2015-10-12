mkdir -p $PREFIX/etc

export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

./configure --prefix=$PREFIX                \
            --enable-etcdir=$PREFIX/etc     \
            --enable-pcre

make
make install

# vim:set ts=8 sw=4 sts=4 tw=78 et:
