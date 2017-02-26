export INCLUDE="$INCLUDE:$PREFIX/include"
export LIB="$LIB:$PREFIX/lib"
export CFLAGS="-I${PREFIX}/include -L${PREFIX}/lib ${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include -L${PREFIX}/lib ${CFLAGS}"
./bootstrap --prefix=$PREFIX
./configure --prefix=$PREFIX
make
make install
