#!/bin/bash

if [ `uname` == Darwin ]; then
    chmod +x configure

    ./configure \
        -platform macx-g++ \
        -release -no-qt3support -nomake examples -nomake demos \
        -opensource \
        -no-framework \
        -arch $OSX_ARCH \
        -prefix $PREFIX

fi

if [ `uname` == Linux ]; then
    chmod +x configure
    ./configure \
        -release -fontconfig -verbose \
        -no-qt3support -nomake examples -nomake demos \
        -qt-libpng -qt-zlib \
        -webkit \
        -prefix $PREFIX
fi

make || exit 1
make install

if [ `uname` == Darwin ]; then
    cd $PREFIX
    rm -rf doc imports mkspecs doc plugins phrasebooks translations \
        q3porting.xml
    cd bin
    rm -rf *.app qcollectiongenerator qhelpgenerator qt3to4 qdoc3
    rm -rf xml* rcc uic moc macdeployqt
fi

if [ `uname` == Linux ]; then
    cp $SRC_DIR/bin/* $PREFIX/bin/
    cd $PREFIX
    rm -rf doc imports mkspecs phrasebooks plugins q3porting.xml translations
    cd $PREFIX/bin
    rm -f *.bat *.pl qt3to4 qdoc3
fi
