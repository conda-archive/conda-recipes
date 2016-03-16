#!/bin/bash

if [ `uname` == Darwin ]; then
    export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib
    MAKE_JOBS=$(sysctl -n hw.ncpu)
fi

if [ `uname` == Linux ]; then
    MAKE_JOBS=$CPU_COUNT
fi

$PYTHON configure.py \
        --verbose \
        --confirm-license \
        --qmake=$PREFIX/bin/qmake-qt5 \
        --assume-shared

make -j $MAKE_JOBS
make install
