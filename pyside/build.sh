#!/bin/bash

mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    -DShiboken_DIR=$PREFIX \
    -DUSE_PYTHON3=$PY3K \
    ..
make
make install

exit 0
# ----------------------------------------------------------

LIB=$PREFIX/lib
SP=$LIB/python2.7/site-packages

if [ `uname` == Darwin ]; then
    mkdir -p $SP
    mkdir $PREFIX/Frameworks
    for dn in /Library/Frameworks/Qt*.framework
    do
        echo $dn
        cp -a $dn $PREFIX/Frameworks/
    done
    find $PREFIX/Frameworks -name "*.h" | xargs rm
    find $PREFIX/Frameworks | grep Headers | xargs rm -rf

    cp /usr/lib/libshiboken-python2.7.1.1.dylib $LIB
    cp /usr/lib/libpyside-python2.7.1.1.dylib $LIB
    cp -r /Library/Python/2.7/site-packages/PySide $SP
    cp -r /Library/Python/2.7/site-packages/pysideuic $SP
    cp /usr/bin/pyside-rcc $PREFIX/bin
    cp /usr/bin/pyside-uic $PREFIX/bin
    cp /usr/bin/pyside-lupdate $PREFIX/bin
fi
