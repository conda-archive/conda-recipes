pushd $SRC_DIR/.build/aarch64-sarc-linux-gnueabi/build/build-binutils-host-x86_64-build_redhat-linux-gnu6E
make DESTDIR=$PREFIX install
popd
