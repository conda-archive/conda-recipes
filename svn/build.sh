./configure --prefix=$PREFIX --with-sqlite=$PREFIX \
            --with-zlib=$PREFIX --with-openssl=$PREFIX
make
make install
