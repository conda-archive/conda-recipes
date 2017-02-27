set -e -x

CHOST="${cpu_arch}-${vendor}-linux-${libc}"

# libtool wants to use ranlib that is here
export PATH=$PATH:${SRC_DIR}/.build/$CHOST/buildtools/bin

pushd ${SRC_DIR}/.build/$CHOST/build/build-cc-gcc-final/

make -C gcc prefix=${PREFIX} install-cpp c++.install-common install-lto-wrapper
make -C lto-plugin prefix=${PREFIX} install
install -dm755 ${PREFIX}/lib/bfd-plugins/

# statically linked, so this so does not exist
# ln -s $PREFIX/lib/gcc/$CHOST/liblto_plugin.so ${PREFIX}/lib/bfd-plugins/

install -m755 -t ${PREFIX}/bin/ gcc/{cc1plus,lto1}

make -C $CHOST/libstdc++-v3/src prefix=${PREFIX} install
make -C $CHOST/libstdc++-v3/include prefix=${PREFIX} install
make -C $CHOST/libstdc++-v3/libsupc++ prefix=${PREFIX} install
make -C $CHOST/libstdc++-v3/python prefix=${PREFIX} install

mkdir -p ${PREFIX}/share/gdb/auto-load/usr/lib/
cp ${SRC_DIR}/gcc_built/${CHOST}/sysroot/lib/libstdc++.so.6.*-gdb.py ${PREFIX}/share/gdb/auto-load/usr/lib/

make -C libcpp prefix=${PREFIX} install

popd
# Install Runtime Library Exception
install -Dm644 $SRC_DIR/.build/src/gcc-${PKG_VERSION}/COPYING.RUNTIME \
        ${PREFIX}/share/licenses/gcc-fortran/RUNTIME.LIBRARY.EXCEPTION

mkdir -p $PREFIX/etc/conda/activate.d
echo "export CHOST=${CHOST}" | cat - $RECIPE_DIR/activate-g++.sh > /tmp/out && mv /tmp/out $PREFIX/etc/conda/activate.d/activate-${PKG_NAME}.sh

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "export CHOST=${CHOST}" | cat - $RECIPE_DIR/deactivate-g++.sh > /tmp/out && mv /tmp/out $PREFIX/etc/conda/deactivate.d/deactivate-${PKG_NAME}.sh
