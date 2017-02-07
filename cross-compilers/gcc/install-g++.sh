pushd $SRC_DIR/.build/aarch64-sarc-linux-gnueabi/build/build-cc-gcc-final/
make DESTDIR=$PREFIX install g++
popd
