./configure --prefix=$PREFIX
make
make install
sed -i -e "s:/usr:$PREFIX:g" $PREFIX/bin/help2man
