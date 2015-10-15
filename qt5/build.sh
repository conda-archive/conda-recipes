#!/bin/bash

CONFIG_OPTS=" "
BIN=$PREFIX/lib/qt5/bin
QTCONF=$BIN/qt.conf

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

    MAKE_JOBS=$(sysctl -n hw.ncpu)
fi

chmod +x configure
./configure -prefix $PREFIX \
            -libdir $PREFIX/lib \
            -bindir $PREFIX/lib/qt5/bin \
            -headerdir $PREFIX/include/qt5 \
            -archdatadir $PREFIX/lib/qt5 \
            -datadir $PREFIX/share/qt5 \
            -L $PREFIX/lib \
            -I $PREFIX/include \
            -release \
            -opensource \
            -confirm-license \
            -shared \
            -nomake examples \
            -nomake tests \
            -no-libudev \
            -gtkstyle \
            -qt-xcb \
            -qt-pcre \
            -qt-xkbcommon \
            -xkb-config-root $PREFIX/lib \
            -verbose \
            $CONFIG_OPTS

make -j $MAKE_JOBS
make install

for file in $BIN/*
do
    ln -sfv ../lib/qt5/bin/$(basename $file) $PREFIX/bin/$(basename $file)-qt5
done

#removes doc, phrasebooks, and translations
rm -rf $PREFIX/share/qt5

# Remove static libs
rm -rf $PREFIX/lib/*.a

# Add qt.conf file to the package to make it fully relocatable
cat <<EOF >$QTCONF
[Paths]
Prefix = $PREFIX/lib/qt5
Libraries = $PREFIX/lib
Headers = $PREFIX/include/qt5

EOF

