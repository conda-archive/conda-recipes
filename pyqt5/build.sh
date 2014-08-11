if [ `uname` == Darwin ]; then
    export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib
    MAKE_JOBS=$(sysctl -n hw.ncpu)
fi

if [ `uname` == Linux ]; then
    MAKE_JOBS=$(nproc)
fi

$PYTHON configure.py \
        --verbose \
        --confirm-license \
        --assume-shared \
        -q $PREFIX/bin/qmake-qt5

make -j $MAKE_JOBS
make install
