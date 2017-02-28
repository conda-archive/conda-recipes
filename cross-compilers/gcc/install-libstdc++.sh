set -e -x

CHOST="${cpu_arch}-${vendor}-linux-${libc}"
pushd $SRC_DIR/.build/$CHOST/build/build-cc-gcc-final/

make -C $CHOST/libstdc++-v3/src prefix=${PREFIX} install-toolexeclibLTLIBRARIES
make -C $CHOST/libstdc++-v3/po prefix=${PREFIX} install

popd

mkdir -p $PREFIX/lib
mv $PREFIX/$CHOST/lib/* $PREFIX/lib

# no static libs
find $PREFIX/lib -name "*\.a" -exec rm -rf {} \;
# no libtool files
find $PREFIX/lib -name "*\.la" -exec rm -rf {} \;

# Install Runtime Library Exception
install -Dm644 $SRC_DIR/.build/src/gcc-${PKG_VERSION}/COPYING.RUNTIME \
        ${PREFIX}/share/licenses/gcc-libs/RUNTIME.LIBRARY.EXCEPTION
