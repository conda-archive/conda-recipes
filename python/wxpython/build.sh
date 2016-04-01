#!/bin/bash

mkdir -vp ${PREFIX}/bin;

MYARCH="$(uname 2>/dev/null)"
MYNCPU=$(( (CPU_COUNT > 8) ? 8 : CPU_COUNT ))

MYCFLAGS=""
if [[ ${ARCH} == 64 ]]; then
    MYCFLAGS="-m64 -march=x86-64"
fi

export CFLAGS="${MYCFLAGS} -pipe -O2 -fPIC"
export CXXFLAGS="${CFLAGS} -std=c++11"
export CPPFLAGS="${CFLAGS} -std=c++11"

LinuxInstallation() {
    # Build dependencies:
    # - gtk+-devel
    # - gtk+extra-devel
    # - gtk2-devel
    # - gtk2-engines-devel
    # - gtkglext-devel
    # - gtkmm24-devel
    # - wxGTK-devel
    # - wxBase
    # - SDL-devel
    # - gstreamer-devel
    # - gstreamer-plugins-base-devel

    chmod +x configure;

    ./configure \
        --enable-utf8 \
        --enable-sound \
        --enable-unicode \
        --enable-monolithic \
        --enable-rpath='$ORIGIN/../lib' \
        --with-gtk \
        --with-sdl \
        --with-expat=builtin \
        --with-libjpeg=builtin \
        --with-libpng=builtin \
        --with-libtiff=builtin \
        --with-regex=builtin \
        --with-zlib=builtin \
        --prefix="${PREFIX}" || return 1;
    make -j ${MYNCPU} || return 1;
    make install || return 1;

    pushd wxPython/;
    ${PYTHON} -u ./setup.py install UNICODE=1 BUILD_BASE=build WX_CONFIG="${PREFIX}/bin/wx-config --prefix=${PREFIX}" \
        --record installed_files.txt --prefix="${PREFIX}" || return 1;
    popd;

    return 0;
}

case ${MYARCH} in
    'Linux')
        LinuxInstallation || exit 1;
        ;;
    *)
        echo -e "Unsupported machine type: ${MYARCH}";
        exit 1;
        ;;
esac
