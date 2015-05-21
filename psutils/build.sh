cp Makefile.unix Makefile
sed -i -e "s:/usr/local:$PREFIX:g" Makefile
make
mkdir -p $PREFIX/share/man/man1
make install
