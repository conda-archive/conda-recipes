set -e -x

CHOST=$(${SRC_DIR}/.build/*-*-*-*/build/build-cc-gcc-final/gcc/xgcc -dumpmachine)

# libtool wants to use ranlib that is here, macOS install doesn't grok -t etc
# .. do we need this scoped over the whole file though?
export PATH=${SRC_DIR}/gcc_built/bin:${SRC_DIR}/.build/${CHOST}/buildtools/bin:${SRC_DIR}/.build/tools/bin:${PATH}

pushd $SRC_DIR/.build/$CHOST/build/build-cc-gcc-final/

make -C $CHOST/libgcc prefix=${PREFIX} install-shared

for lib in libatomic libgomp libquadmath libitm libvtv libsanitizer/{a,l,ub,t}tsan; do
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
