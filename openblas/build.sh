#/bin/bash

make NO_AFFINITY=1 NUM_THREADS=1 DYNAMIC_ARCH=1 NO_STATIC=1 PREFIX=$PREFIX -j${CPU_COUNT}
make install PREFIX=$PREFIX

ln -fs $PREFIX/lib/libopenblas.a $PREFIX/lib/libblas.a
ln -fs $PREFIX/lib/libopenblas.a $PREFIX/lib/liblapack.a

ln -fs $PREFIX/lib/libopenblas.$DYLIB_EXT $PREFIX/lib/libblas.$DYLIB_EXT
ln -fs $PREFIX/lib/libopenblas.$DYLIB_EXT $PREFIX/lib/liblapack.$DYLIB_EXT
