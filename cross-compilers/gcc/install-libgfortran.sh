set -e -x

CHOST="${cpu_arch}-${vendor}-linux-${libc}"

mkdir -p $PREFIX/lib
cp ${SRC_DIR}/gcc_built/$CHOST/sysroot/lib/libgfortran.so.3.0.0 $PREFIX/lib
ln -s $PREFIX/lib/libgfortran.so.3.0.0 $PREFIX/lib/libgfortran.so.3
ln -s $PREFIX/lib/libgfortran.so.3.0.0 $PREFIX/lib/libgfortran.so

# Install Runtime Library Exception
install -Dm644 $SRC_DIR/.build/src/gcc-${PKG_VERSION}/COPYING.RUNTIME \
        ${PREFIX}/share/licenses/gcc-libs/RUNTIME.LIBRARY.EXCEPTION
