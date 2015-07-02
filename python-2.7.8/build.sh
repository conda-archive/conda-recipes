#!/bin/bash

rm -rf Lib/test Lib/*/test

if [ `uname` == Darwin ]; then
    export CFLAGS="-I$PREFIX/include $CFLAGS"
    export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
    $REPLACE "@OSX_ARCH@" "'$OSX_ARCH'" Lib/distutils/unixccompiler.py
fi

./configure --enable-shared --enable-ipv6 --enable-unicode=ucs4 \
    --prefix=$PREFIX
make
make install

if [ `uname` == Darwin ]; then
    DYNLOAD_DIR=$STDLIB_DIR/lib-dynload
    if [ $ARCH == 64 ]; then
        rm $DYNLOAD_DIR/_hashlib_failed.so
        rm $DYNLOAD_DIR/_ssl_failed.so
        rm $DYNLOAD_DIR/_tkinter_failed.so
        pushd Modules
        rm -rf build
        cp $RECIPE_DIR/setup_osx.py .
        $PYTHON setup_osx.py build
        cp build/lib.macosx-*/_hashlib.so \
           build/lib.macosx-*/_ssl.so \
           build/lib.macosx-*/_tkinter.so \
               $DYNLOAD_DIR
        popd
    fi
fi
if [ `uname` == Linux ]; then
    pushd $PREFIX/bin
    rm python2-config python-config
    mv python2.7-config python-config
    popd
fi
