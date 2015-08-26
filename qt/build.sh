#!/bin/bash

BIN=$PREFIX/bin
QTCONF=$BIN/qt.conf

if [ `uname` == Linux ]; then
    chmod +x configure

    if [ $ARCH == 64 ]; then
        MARCH=x86-64
    else
        MARCH=i686
    fi

    # Building QtWebKit on CentOS 5 fails without setting these flags
    # explicitly. This is caused by using an old gcc version
    # See https://bugs.webkit.org/show_bug.cgi?id=25836#c5
    CFLAGS="-march=${MARCH}" CXXFLAGS="-march=${MARCH}" \
    CPPFLAGS="-march=${MARCH}" LDFLAGS="-march=${MARCH}" \
    ./configure \
        -release -fast -prefix $PREFIX \
        -no-qt3support -nomake examples -nomake demos -nomake docs \
        -opensource -verbose -openssl -webkit -gtkstyle -dbus \
        -system-libpng -qt-zlib -L $LIBRARY_PATH -I $INCLUDE_PATH

    # Build on RPM based distros fails without setting LD_LIBRARY_PATH
    # to the build lib dir
    # See https://bugreports.qt.io/browse/QTBUG-5385
    LD_LIBRARY_PATH=$SRC_DIR/lib make -j $CPU_COUNT
    
    make install

    cp $SRC_DIR/bin/* $PREFIX/bin/
    cd $PREFIX
    rm -rf doc phrasebooks q3porting.xml translations
    rm -rf demos examples
    cd $PREFIX/bin
    rm -f *.bat *.pl qt3to4 qdoc3
fi

if [ `uname` == Darwin ]; then
    # Leave Qt set its own flags and vars, else compilation errors
    # will occur
    for x in OSX_ARCH CFLAGS CXXFLAGS LDFLAGS
    do
	unset $x
    done

    chmod +x configure
    ./configure \
        -release -fast -prefix $PREFIX -platform macx-g++ \
        -no-qt3support -nomake examples -nomake demos -nomake docs \
        -opensource -verbose -openssl -no-framework -system-libpng \
        -arch `uname -m` -L $LIBRARY_PATH -I $INCLUDE_PATH

    make -j $(sysctl -n hw.ncpu)
    make install
fi

# Make sure $BIN exists
if [ ! -d $BIN ]; then
  mkdir $BIN
fi

# Add qt.conf file to the package to make it fully relocatable
cat <<EOF >$QTCONF
[Paths]
Prefix = $PREFIX

EOF
