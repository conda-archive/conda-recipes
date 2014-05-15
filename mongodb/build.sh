#!/bin/bash

MACHINE="$(uname 2>/dev/null)"

export CFLAGS="-Wall -g -m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

LinuxInstallation() {
    # Build dependencies:
    # - pcre-devel

    scons \
        --ssl \
        --prefix="${PREFIX}" \
        all || return 1;

    scons \
        --prefix="${PREFIX}" \
        install || return 1;

    return 0;
}

case ${MACHINE} in
    'Linux')
        LinuxInstallation || exit 1;
        ;;
    *)
        echo -e "Unsupported machine type: ${MACHINE}";
        exit 1;
        ;;
esac
