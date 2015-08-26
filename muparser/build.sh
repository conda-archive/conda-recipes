sh ./configure --prefix=$PREFIX --disable-samples
make -j${CPU_COUNT}
make install
