set -e -x

CHOST="${cpu_arch}-${vendor}-linux-${libc}"
pushd $SRC_DIR/.build/$CHOST/build/build-cc-gcc-final/

make -C $CHOST/libgcc prefix=${PREFIX} install-shared

# omits:
# libitm \
# libvtv \
# libsanitizer/{a,l,ub}san \

for lib in libatomic libgomp libquadmath; do
    make -C $CHOST/$lib prefix=${PREFIX} install-toolexeclibLTLIBRARIES
done

# make -C $CHOST/libsanitizer/tsan DESTDIR=${PREFIX} install-toolexeclibLTLIBRARIES

# omits:
# libitm \

for lib in libgomp libquadmath; do
    make -C $CHOST/$lib prefix=${PREFIX} install-info
done

popd

mkdir -p $PREFIX/lib
mv $PREFIX/$CHOST/lib/* $PREFIX/lib

# no static libs
find $PREFIX/lib -name "*\.a" -exec rm -rf {} \;
# no libtool files
find $PREFIX/lib -name "*\.la" -exec rm -rf {} \;
# clean up empty folder
rm -rf $PREFIX/lib/gcc

# Install Runtime Library Exception
install -Dm644 $SRC_DIR/.build/src/gcc-${PKG_VERSION}/COPYING.RUNTIME \
        ${PREFIX}/share/licenses/gcc-libs/RUNTIME.LIBRARY.EXCEPTION
