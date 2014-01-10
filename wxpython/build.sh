#!/bin/bash

mkdir -vp ${PREFIX}/bin;

ARCH="$(uname 2>/dev/null)"

export CFLAGS="-m64 -pipe -O2 -march=x86-64 -fPIC"
export CXXLAGS="${CFLAGS}"
#export CPPFLAGS="-I${PREFIX}/include"
#export LDFLAGS="-L${PREFIX}/lib64"

sed -i 's/\(CORE_ONLY\)\s*=\s*0\(.*\)/\1 = 1\2/' wxPython/config.py

LinuxInstallation() {

    #chmod +x configure;

    #./configure \
    #    --with-gtk \
    #    --enable-unicode \
    #    --with-libjpeg=builtin \
    #    --with-libpng=builtin \
    #    --with-libtiff=builtin \
    #    --with-zlib=builtin \
    #    --prefix ${PREFIX} || return 1;
    #make || return 1;
    #make install || return 1;

    pushd wxPython/;

    ${PYTHON} setup.py install || exit 1;

    popd;

    return 0;
}

case ${ARCH} in
    'Linux')
        LinuxInstallation || exit 1;
        ;;
    *)
        echo -e "Unsupported machine type: ${ARCH}";
        exit 1;
        ;;
esac

#POST_LINK="${PREFIX}/bin/.wxpython-post-link.sh"
#cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
#chmod -v 0755 ${POST_LINK};
