set -e -x

CHOST=$(${SRC_DIR}/.build/*-*-*-*/build/build-cc-gcc-final/gcc/xgcc -dumpmachine)

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
