make rx CFLAGS="-I$PREFIX/include"
make rs CFLAGS="-I$PREFIX/include"
mkdir -p $PREFIX/bin
cp minisat+_script minisat+_64-bit_static minisat+_bignum_static $PREFIX/bin
