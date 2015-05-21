if [ `uname` == Darwin ]; then
    CXX=clang++ CC=clang python scripts/mk_make.py --prefix=$PREFIX
else
    python scripts/mk_make.py --prefix=$PREFIX
fi
cd build
make
make install
