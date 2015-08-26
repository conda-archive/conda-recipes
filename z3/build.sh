if [ `uname` == Darwin ]; then
    CXX=clang++ CC=clang python scripts/mk_make.py --prefix=$PREFIX
else
    python scripts/mk_make.py --prefix=$PREFIX
fi
cd build
make
make install

# https://github.com/Z3Prover/z3/issues/99
mv $STDLIB_DIR/dist-packages/* $SP_DIR/
