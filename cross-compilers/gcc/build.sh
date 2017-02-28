CHOST="${arch}-${vendor}-linux-${libc}"
mkdir -p .build/src
mkdir -p .build/tarballs
if [[ ! -e ".build/tarballs/linux-2.6.18.tar.xz" ]]; then
    curl -L https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.18.tar.xz -o $(pwd)/.build/tarballs/linux-2.6.18.tar.xz;
fi

cp $RECIPE_DIR/.config .config

# If dirty is unset or the binary doesn't exist yet, then run ct-ng
if [[ ! -e "${SRC_DIR}/gcc_built/bin/${CHOST}-gcc" ]]; then
   ct-ng build;
fi

# increase stack size to prevent test failures
# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31827
ulimit -s 32768

# pushd .build/${CHOST}/build/build-cc-gcc-final
# make -k check || true
# popd

# .build/src/gcc-${PKG_VERSION}/contrib/test_summary

chmod 755 -R $PREFIX
