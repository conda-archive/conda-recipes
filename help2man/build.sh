./configure --prefix=$PREFIX
make
make install
sed -i -e "s:/usr/local:$PREFIX:g" $PREFIX/bin/help2man
