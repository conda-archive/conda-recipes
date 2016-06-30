mkdir -p $PREFIX/bin
cd $SRC_DIR
make
cp ./build/execs/xhmm $PREFIX/bin
