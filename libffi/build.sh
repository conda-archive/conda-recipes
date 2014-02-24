./configure --prefix=$PREFIX
make
make install
if [ -e $PREFIX/lib64 ]; then
    cp $PREFIX/lib64/* $PREFIX/lib/
fi
