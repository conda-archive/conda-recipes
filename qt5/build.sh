#!/bin/bash

CONFIG_OPTS=" "

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

if [ -f /etc/redhat-release ] && grep "CentOS release 5" /etc/redhat-release; then

    # Disable perf events. This file won't compile because of a broken kernel header in CentOS 5.
    # See http://lists.qt-project.org/pipermail/interest/2015-February/015306.html for error.
    sed -i "s/#define QTESTLIB_USE_PERF_EVENTS/#undef QTESTLIB_USE_PERF_EVENTS/g" qtbase/src/testlib/qbenchmark_p.h

    # See http://kate-editor.org/2014/12/22/qt-5-4-on-red-hat-enterprise-5/ for explanation
    # of these options. Basically, these things are left undefined becuase of CentOS 5
    # problems.
    CONFIG_OPTS+=" -D _X_INLINE=inline"  # Fix xcb compilation error
    CONFIG_OPTS+=" -D XK_dead_currency=0xfe6f"
    CONFIG_OPTS+=" -D XK_ISO_Level5_Lock=0xfe13"
    CONFIG_OPTS+=" -D FC_WEIGHT_EXTRABLACK=215"
    CONFIG_OPTS+=" -D FC_WEIGHT_ULTRABLACK=FC_WEIGHT_EXTRABLACK"

    CONFIG_OPTS+=" -D glXGetProcAddress=glXGetProcAddressARB"

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
            -qt-xcb \
            -qt-pcre \
            -qt-xkbcommon \
            $CONFIG_OPTS

make -j $MAKE_JOBS
make install

for file in $PREFIX/lib/qt5/bin/*
do
    ln -sfv ../lib/qt5/bin/$(basename $file) $PREFIX/bin/$(basename $file)-qt5
done

#removes doc, phrasebooks, and translations
rm -rf $PREFIX/share/qt5
