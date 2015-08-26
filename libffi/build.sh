./configure --prefix=$PREFIX
make
make install
if [ -e $PREFIX/lib64 ]; then
    mv $PREFIX/lib64/* $PREFIX/lib/
    rmdir $PREFIX/lib64
fi
