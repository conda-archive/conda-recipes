#!/bin/bash

# Main variables
# --------------
BIN=$PREFIX/lib/qt5/bin
QTCONF=$BIN/qt.conf
VER=$PKG_VERSION


# Download QtWebkit
# -----------------
curl "http://linorg.usp.br/Qt/community_releases/5.6/${VER}/qtwebkit-opensource-src-${VER}.tar.xz" > qtwebkit.tar.xz
unxz qtwebkit.tar.xz
tar xf qtwebkit.tar
mv qtwebkit-opensource-src* qtwebkit
rm qtwebkit.tar


# Compile
# -------
chmod +x configure

if [ `uname` == Linux ]; then
    MAKE_JOBS=$CPU_COUNT

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
                -verbose \
                -skip webengine \
                -skip enginio \
                -skip location \
                -skip sensors \
                -skip serialport \
                -skip script \
                -skip serialbus \
                -skip quickcontrols2 \
                -skip wayland \
                -skip canvas3d \
                -skip 3d \
                -qt-pcre \
                -no-linuxfb \
                -no-libudev \
                -qt-xcb \
                -qt-xkbcommon \
                -xkb-config-root $PREFIX/lib \
                -dbus
                #-gtkstyle \
                #-no-evdev \
                #-DGLX_GLXEXT_LEGACY \
                #-D_X_INLINE=inline \
                #-DXK_dead_currency=0xfe6f \
                #-DXK_ISO_Level5_Lock=0xfe13

    LD_LIBRARY_PATH=$PREFIX/lib make -j $MAKE_JOBS
    make install

fi


if [ `uname` == Darwin ]; then
    # Let Qt set its own flags and vars
    for x in OSX_ARCH CFLAGS CXXFLAGS LDFLAGS
    do
        unset $x
    done

    MACOSX_DEPLOYMENT_TARGET=10.7
    MAKE_JOBS=$(sysctl -n hw.ncpu)

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
                -verbose \
                -skip webengine \
                -skip enginio \
                -skip location \
                -skip sensors \
                -skip serialport \
                -skip script \
                -skip serialbus \
                -skip quickcontrols2 \
                -skip wayland \
                -skip canvas3d \
                -skip 3d \
                -qt-pcre \
                -qt-freetype \
                -platform macx-g++ \
                -no-c++11 \
                -no-framework \
                -no-dbus \
                -no-mtdev \
                -no-harfbuzz \
                -no-xinput2 \
                -no-xcb-xlib \
                -no-libudev \
                -no-egl

    DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib make -j $MAKE_JOBS
    make install

fi

# Post build setup
# ----------------

# Remove unneeded files
rm -rf $PREFIX/share/qt5

# Make symlinks of binaries in $BIN to $PREFIX/bin
for file in $BIN/*
do
    ln -sfv ../lib/qt5/bin/$(basename $file) $PREFIX/bin/$(basename $file)-qt5
done

# Remove static libs
rm -rf $PREFIX/lib/*.a

# Add qt.conf file to the package to make it fully relocatable
cp $RECIPE_DIR/qt.conf $BIN/
