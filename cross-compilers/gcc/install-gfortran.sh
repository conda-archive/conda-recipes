set -e -x

CHOST="${cpu_arch}-${vendor}-linux-${libc}"

_libdir="libexec/gcc/$CHOST/$PKG_VERSION"
pushd $SRC_DIR/.build/$CHOST/build/build-cc-gcc-final/

# adapted from Arch install script from https://github.com/archlinuxarm/PKGBUILDs/blob/master/core/gcc/PKGBUILD
make -C $CHOST/libgfortran prefix=$PREFIX install-cafexeclibLTLIBRARIES \
     install-{toolexeclibDATA,nodist_fincludeHEADERS}
make -C $CHOST/libgomp prefix=$PREFIX install-nodist_fincludeHEADERS
make -C gcc prefix=$PREFIX fortran.install-{common,man,info}
install -Dm755 gcc/f951 $PREFIX/${_libdir}/f951

if [ ! -e ${PREFIX}/bin/f95 ]; then
    ln -s $PREFIX/bin/$CHOST-gfortran $PREFIX/bin/f95
fi

popd

# Install Runtime Library Exception
install -Dm644 $SRC_DIR/.build/src/gcc-${PKG_VERSION}/COPYING.RUNTIME \
        ${PREFIX}/share/licenses/gcc-fortran/RUNTIME.LIBRARY.EXCEPTION

mkdir -p $PREFIX/etc/conda/activate.d
echo "export CHOST=${CHOST}" | cat - $RECIPE_DIR/activate-gfortran.sh > /tmp/out && mv /tmp/out $PREFIX/etc/conda/activate.d/activate-${PKG_NAME}.sh

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "export CHOST=${CHOST}" | cat - $RECIPE_DIR/deactivate-gfortran.sh > /tmp/out && mv /tmp/out $PREFIX/etc/conda/deactivate.d/deactivate-${PKG_NAME}.sh
