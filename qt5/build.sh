#!/bin/bash

# change qt.conf name for qt4 coexistence
patch -p1 <$RECIPE_DIR/qt5_conf.patch

if [ `uname` == Linux ]; then
    MAKE_JOBS=$CPU_COUNT

    # see https://doc.qt.io/qt-5/linux-requirements.html
    ./configure \
        -verbose \
        -prefix $PREFIX \
        -bindir $PREFIX/lib/qt5/bin \
        -headerdir $PREFIX/include/qt5 \
        -libdir $PREFIX/lib \
        -archdatadir $PREFIX/lib/qt5 \
        -datadir $PREFIX/share/qt5 \
        -L $PREFIX/lib \
        -R $PREFIX/lib \
        -I $PREFIX/include \
        -opensource \
        -confirm-license \
        -release \
        -shared \
        -nomake examples \
        -nomake tests \
        -skip enginio \
        -qt-pcre \
        -system-xkbcommon-x11 \
        -no-gtkstyle \
        -dbus \
        -no-gstreamer
fi

if [ `uname` == Darwin ]; then
    # Let Qt set its own flags and vars
    for x in OSX_ARCH CFLAGS CXXFLAGS LDFLAGS; do
        unset $x
    done

    MACOSX_DEPLOYMENT_TARGET=10.7
    MAKE_JOBS=$(sysctl -n hw.ncpu)

    ./configure \
        -platform macx-g++ \
        -verbose \
        -prefix $PREFIX \
        -bindir $PREFIX/lib/qt5/bin \
        -headerdir $PREFIX/include/qt5 \
        -libdir $PREFIX/lib/qt5 \
        -archdatadir $PREFIX/lib/qt5 \
        -datadir $PREFIX/share/qt5 \
        -L $PREFIX/lib \
        -R $PREFIX/lib \
        -I $PREFIX/include \
        -opensource \
        -confirm-license \
        -release \
        -shared \
        -nomake examples \
        -nomake tests \
        -skip qtwebengine \
        -qt-pcre \
        -no-c++11 \
        -no-framework \
        -no-dbus \
        -no-mtdev \
        -no-harfbuzz \
        -no-xinput2 \
        -no-xcb-xlib \
        -no-libudev \
        -no-egl
fi

make -j $MAKE_JOBS
make install

for file in $PREFIX/lib/qt5/bin/*; do
    ln -sfv ../lib/qt5/bin/$(basename $file) $PREFIX/bin/$(basename $file)-qt5
done

#removes doc, phrasebooks, and translations
rm -rfv $PREFIX/share/qt5

# Remove static libs
rm -rfv $PREFIX/lib/*.a

# Add qt.conf file to the package to make it fully relocatable
cp $RECIPE_DIR/qt5_unix.conf $PREFIX/bin/qt5.conf
echo "Prefix = .." >>$PREFIX/bin/qt5.conf

cp $RECIPE_DIR/qt5_unix.conf $PREFIX/lib/qt5/bin/qt5.conf
echo "Prefix = ../../.." >>$PREFIX/lib/qt5/bin/qt5.conf
