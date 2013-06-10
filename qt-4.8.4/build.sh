#!/bin/bash

set -e

sed -i "s/read acceptance/acceptance=yes/g" configure
sed -i "s/read commercial/commercial=o/g" configure

if [ `uname` == Darwin ]; then
    patch -p0 <$PKG_PATH/10.5.patch || exit 1
    chmod +x configure

    ./configure \
        -platform macx-g++ \
        -release -no-qt3support -nomake examples -nomake demos \
        -opensource \
        -no-framework \
        -sdk $SDK \
        -arch $OSX_ARCH \
        -prefix $PREFIX

    for x in $(find . -name Makefile); do
      sed -i "s_-arch -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk__g" $x
    done
fi

if [ `uname` == Linux ]; then
    chmod +x configure
    ./configure \
        -release -fontconfig -continue -verbose \
        -no-qt3support -nomake examples -nomake demos \
        -qt-libpng -qt-zlib \
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
