./configure --prefix=$PREFIX --with-pic

make -j ${CPU_COUNT}
make check
make install
