set -e -x

CHOST=$(${SRC_DIR}/.build/*-*-*-*/build/build-cc-gcc-final/gcc/xgcc -dumpmachine)
pushd $SRC_DIR/.build/$CHOST/build/build-cc-gcc-final/

make -C $CHOST/libgcc prefix=${PREFIX} install-shared

# omits:
# libitm \
# libvtv \
# libsanitizer/{a,l,ub}san \

for lib in libatomic libgomp libquadmath libitm libsanitizer/tsan; do
    if [[ -d $CHOST/$lib ]]; then
        make -C $CHOST/$lib prefix=${PREFIX} install-toolexeclibLTLIBRARIES
    fi
done

for lib in libgomp libquadmath; do
    if [[ -d $CHOST/$lib ]]; then
      make -C $CHOST/$lib prefix=${PREFIX} install-info
    fi
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
