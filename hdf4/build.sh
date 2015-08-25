#!/bin/bash

mkdir -vp ${PREFIX}/bin;

ARCH="$(uname 2>/dev/null)"

case ${ARCH} in
    'Darwin')
        export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib
        export CPPFLAGS="-I${PREFIX}/include"
        ;;
    'Linux')
        export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
        export CPPFLAGS="-I${PREFIX}/include -fPIC"
        ;;
    *)
        echo -e "Unsupported machine type: ${ARCH}";
        exit 1;
        ;;
esac

chmod +x configure;

./configure \
    --disable-netcdf \
    --enable-fortran=no \
    --with-jpeg=${PREFIX} \
    --disable-static \
    --with-zlib \
    --prefix=${PREFIX} || return 1;
make  || exit 1;
make check || exit 1;
make install || exit 1;

rm -rf ${PREFIX}/share/hdf4_examples;

exit 0;
