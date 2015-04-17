cp Makefile.unix Makefile
sed -i -e "s:/usr/local:$PREFIX:g" Makefile
make
make install
