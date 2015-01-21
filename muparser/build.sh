sh ./configure --prefix=$PREFIX --disable-samples
make -j$(getconf _NPROCESSORS_ONLN)
make install
