set -e -x

CHOST=$(${SRC_DIR}/.build/*-*-*-*/build/build-cc-gcc-final/gcc/xgcc -dumpmachine)

# libtool wants to use ranlib that is here, macOS install doesn't grok -t etc
# .. do we need this scoped over the whole file though?
export PATH=${SRC_DIR}/gcc_built/bin:${SRC_DIR}/.build/${CHOST}/buildtools/bin:${SRC_DIR}/.build/tools/bin:${PATH}

mkdir -p $PREFIX/lib
rm -f $PREFIX/lib/libgfortran* || true

cp ${SRC_DIR}/gcc_built/$CHOST/sysroot/lib/libgfortran.so.3.0.0 $PREFIX/lib
pushd $PREFIX/lib
  ln -s libgfortran.so.3.0.0 libgfortran.so.3.0
  ln -s libgfortran.so.3.0 libgfortran.so
popd

# Install Runtime Library Exception
install -Dm644 $SRC_DIR/.build/src/gcc-${PKG_VERSION}/COPYING.RUNTIME \
        ${PREFIX}/share/licenses/gcc-libs/RUNTIME.LIBRARY.EXCEPTION
