

if [[ `uname` == 'Darwin' ]]; then
    DYLIB_EXT=dylib
else
    DYLIB_EXT=so
fi

make DYNAMIC_ARCH=1 BINARY=${ARCH} NO_LAPACK=0 NO_AFFINITY=1 NUM_THREADS=1 -j${CPU_COUNT}
make install PREFIX=$PREFIX

if [[ `uname` == 'Darwin' ]]; then
    GFORTRAN_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libgfortran.3.dylib)\"))")
    GCC_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libgcc_s.1.dylib)\"))")
    QUADMATH_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libquadmath.0.dylib)\"))")
    install_name_tool -change $GFORTRAN_LIB @rpath/libgfortran.3.dylib $PREFIX/lib/libopenblas.dylib
    install_name_tool -change $GCC_LIB @rpath/libgcc_s.1.dylib $PREFIX/lib/libopenblas.dylib
    install_name_tool -change $QUADMATH_LIB @rpath/libquadmath.0.dylib $PREFIX/lib/libopenblas.dylib
fi

ln -fs $PREFIX/lib/libopenblas.a $PREFIX/lib/libblas.a
ln -fs $PREFIX/lib/libopenblas.a $PREFIX/lib/liblapack.a

ln -fs $PREFIX/lib/libopenblas.$DYLIB_EXT $PREFIX/lib/libblas.$DYLIB_EXT
ln -fs $PREFIX/lib/libopenblas.$DYLIB_EXT $PREFIX/lib/liblapack.$DYLIB_EXT
