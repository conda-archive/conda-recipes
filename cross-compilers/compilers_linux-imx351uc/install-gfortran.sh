set -e -x

CHOST=$(${SRC_DIR}/.build/*-*-*-*/build/build-cc-gcc-final/gcc/xgcc -dumpmachine)
_libdir="libexec/gcc/$CHOST/$PKG_VERSION"

# libtool wants to use ranlib that is here, macOS install doesn't grok -t etc
# .. do we need this scoped over the whole file though?
export PATH=${SRC_DIR}/gcc_built/bin:${SRC_DIR}/.build/${CHOST}/buildtools/bin:${SRC_DIR}/.build/tools/bin:${PATH}

pushd $SRC_DIR/.build/$CHOST/build/build-cc-gcc-final/

make -C $CHOST/libgfortran prefix=$PREFIX install
if [[ -d $CHOST/libgomp ]]; then
  make -C $CHOST/libgomp prefix=$PREFIX install-nodist_fincludeHEADERS
fi
make -C gcc prefix=$PREFIX fortran.install-{common,man,info}
install -Dm755 gcc/f951 $PREFIX/${_libdir}/f951

pushd $PREFIX/bin
  ln -s $CHOST-gfortran $CHOST-f95
popd

popd

# Install Runtime Library Exception
install -Dm644 $SRC_DIR/.build/src/gcc-${PKG_VERSION}/COPYING.RUNTIME \
        ${PREFIX}/share/licenses/gcc-fortran/RUNTIME.LIBRARY.EXCEPTION

mkdir -p ${PREFIX}/etc/conda/{de,}activate.d
cp "${SRC_DIR}"/activate-gfortran.sh ${PREFIX}/etc/conda/activate.d/activate-${PKG_NAME}.sh
cp "${SRC_DIR}"/deactivate-gfortran.sh ${PREFIX}/etc/conda/deactivate.d/deactivate-${PKG_NAME}.sh
