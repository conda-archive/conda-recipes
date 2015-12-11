PYTHON=$PREFIX/bin/python${PY_VER} ./configure --prefix=$PREFIX --enable-shared --without-octave --without-matlab --without-guile
make -j${CPU_COUNT}
make install
