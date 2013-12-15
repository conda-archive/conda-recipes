#!/bin/bash

mkdir -vp ${PREFIX}/bin;

MACHINE="$(uname 2>/dev/null)"

export CFLAGS="-m64 -pipe -O2 -march=x86-64 -fPIC -lboost_system"
export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

LinuxInstallation() {

    chmod +x configure;

    ./configure \
        --prefix ${PREFIX} || return 1;
    make || return 1;
    make install || return 1;

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

POST_LINK="${PREFIX}/bin/.openexr-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};

