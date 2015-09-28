#!/bin/bash

CONFIG_OPTS=" "
PATH=/usr/bin:/usr/sbin:/bin

if [ `uname` == Linux ]; then
    CONFIG_OPTS+=" -dbus"
    MAKE_JOBS=$CPU_COUNT
fi

if [ `uname` == Darwin ]; then
    # Let Qt set its own flags and vars
    for x in OSX_ARCH CFLAGS CXXFLAGS LDFLAGS
    do
        unset $x
    done

    MACOSX_DEPLOYMENT_TARGET=10.7

    CONFIG_OPTS+=" -platform macx-g++ -no-framework -no-c++11"
    CONFIG_OPTS+=" -no-mtdev -no-harfbuzz -no-xinput2 -no-xcb-xlib"
    CONFIG_OPTS+=" -no-libudev -no-egl"
fi

chmod +x configure
./configure -prefix $PREFIX \
            -libdir $PREFIX/lib \
            -bindir $PREFIX/lib/qt5/bin \
            -headerdir $PREFIX/include/qt5 \
            -archdatadir $PREFIX/lib/qt5 \
            -datadir $PREFIX/share/qt5 \
            -release \
            -opensource \
            -confirm-license \
            -shared \
            -nomake examples \
            -nomake tests \
            -fontconfig \
            -qt-libpng \
            -qt-zlib \
            $CONFIG_OPTS

make -j ${CPU_COUNT}
make install

for file in $PREFIX/lib/qt5/bin/*
do
    ln -sfv ../lib/qt5/bin/$(basename $file) $PREFIX/bin/$(basename $file)-qt5
done

#removes doc, phrasebooks, and translations
rm -rf $PREFIX/share/qt5
