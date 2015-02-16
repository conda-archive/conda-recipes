if [ `uname` == Darwin ]; then
    export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib
    MAKE_JOBS=$(sysctl -n hw.ncpu)
fi


# Build is running out of memory on Linux with several
# cores
if [ `uname` == Linux ]; then
    MAKE_JOBS=1
fi


$PYTHON configure.py \
        --verbose \
        --confirm-license \
        --assume-shared \
        -q $PREFIX/bin/qmake-qt5

make -j $MAKE_JOBS
make install
