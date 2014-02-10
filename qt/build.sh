#!/bin/bash

if [ `uname` == Linux ]; then
    chmod +x configure
    ./configure \
        -release -fontconfig -continue -verbose \
        -no-qt3support -nomake examples -nomake demos \
        -webkit -qt-libpng -qt-zlib -gtkstyle \
        -prefix $PREFIX
    make
    make install

    cp $SRC_DIR/bin/* $PREFIX/bin/
    cd $PREFIX
    rm -rf doc imports mkspecs phrasebooks plugins q3porting.xml translations
    rm -rf demos examples tests
    cd $PREFIX/bin
    rm -f *.bat *.pl qt3to4 qdoc3
fi

if [ `uname` == Darwin ]; then
    chmod +x configure
    ./configure \
        -platform macx-g++ \
        -release -no-qt3support -nomake examples -nomake demos \
        -opensource \
        -no-framework \
        -sdk $SDK \
        -arch $ARCH \
        -prefix $PREFIX

    make
    make install

    # cd $PREFIX
    # for fn in lconvert lrelease lupdate macdeployqt moc qmake rcc uic
    # do
    #     cp /usr/bin/$fn $PREFIX/bin
    # done
    #
    # for x in QtCore QtDBus QtDeclarative QtGui QtMultimedia QtNetwork \
    #     QtOpenGL QtScript QtSql QtSvg QtWebKit QtXml QtXmlPatterns phonon
    # do
    #     cd $PREFIX/include
    #     cp -r /Library/Frameworks/$x.framework/Versions/4/Headers $x
    #
    #     cd $PREFIX/lib
    #     fn=lib$x.4.8.5.dylib
    #     cp /Library/Frameworks/$x.framework/Versions/4/$x $fn
    #     chmod +x $fn
    #     ln -s $fn lib$x.4.8.dylib
    #     ln -s $fn lib$x.4.dylib
    #     ln -s $fn lib$x.dylib
    # done
fi
