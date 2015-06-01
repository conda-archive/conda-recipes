./configure --enable-shared --enable-ipv6 --prefix=$PREFIX
make
make install

cd $PREFIX/bin
ln -s python3.4 python
ln -s pydoc3.4 pydoc
