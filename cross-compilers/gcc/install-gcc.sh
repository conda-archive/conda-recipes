set -e -x

CHOST="${cpu_arch}-${vendor}-linux-${libc}"

# libtool wants to use ranlib that is here
export PATH=$PATH:${SRC_DIR}/.build/$CHOST/buildtools/bin

# pushd ${SRC_DIR}/.build/src/glibc-${glibc}
# make prefix=${PREFIX} install-headers
# popd

pushd ${SRC_DIR}/.build/$CHOST/build/build-cc-gcc-final/
make -C gcc prefix=${PREFIX} install-driver install-gcc-ar install-headers install-plugin

install -m755 -t ${PREFIX}/bin/ gcc/gcov{,-tool}
install -m755 -t ${PREFIX}/bin/ gcc/{cc1,collect2}

make -C $CHOST/libgcc prefix=${PREFIX} install
# rm ${PREFIX}/lib/libgcc_s.so*

make prefix=${PREFIX} install-libcc1
install -d ${PREFIX}/share/gdb/auto-load/usr/lib

make prefix=${PREFIX} install-fixincludes
make -C gcc prefix=${PREFIX} install-mkheaders

make -C $CHOST/libgomp prefix=${PREFIX} install-nodist_toolexeclibHEADERS \
install-nodist_libsubincludeHEADERS
# make -C $CHOST/libitm DESTDIR=${PREFIX} install-nodist_toolexeclibHEADERS
make -C $CHOST/libquadmath prefix=${PREFIX} install-nodist_libsubincludeHEADERS
# make -C $CHOST/libsanitizer DESTDIR=${PREFIX} install-nodist_{saninclude,toolexeclib}HEADERS
# make -C $CHOST/libsanitizer/asan DESTDIR=${PREFIX} install-nodist_toolexeclibHEADERS

make -C libiberty prefix=${PREFIX} install
# install PIC version of libiberty
install -m644 libiberty/pic/libiberty.a ${PREFIX}/lib

make -C gcc prefix=${PREFIX} install-man install-info

make -C gcc prefix=${PREFIX} install-po

# many packages expect this symlink
if [ ! -e ${PREFIX}/bin/cc ]; then
    ln -s ${PREFIX}/bin/${CHOST}-gcc ${PREFIX}/bin/cc
fi

# POSIX conformance launcher scripts for c89 and c99
cat > ${PREFIX}/bin/c89 <<"EOF"
#!/bin/sh
fl="-std=c89"
for opt; do
  case "$opt" in
    -ansi|-std=c89|-std=iso9899:1990) fl="";;
    -std=*) echo "`basename $0` called with non ANSI/ISO C option $opt" >&2
      exit 1;;
  esac
done
exec gcc $fl ${1+"$@"}
EOF

  cat > ${PREFIX}/bin/c99 <<"EOF"
#!/bin/sh
fl="-std=c99"
for opt; do
  case "$opt" in
    -std=c99|-std=iso9899:1999) fl="";;
    -std=*) echo "`basename $0` called with non ISO C99 option $opt" >&2
      exit 1;;
  esac
done
exec gcc $fl ${1+"$@"}
EOF

chmod 755 ${PREFIX}/bin/c{8,9}9

# duplicate executable - taking up space?  Is it a hardlink?
# rm $PREFIX/bin/${CHOST}-gcc-${PKG_VERSION}

mkdir -p $PREFIX/$CHOST
cp -r ${SRC_DIR}/gcc_built/${CHOST}/sysroot/usr/include $PREFIX/${CHOST}

popd
# Install Runtime Library Exception
install -Dm644 $SRC_DIR/.build/src/gcc-${PKG_VERSION}/COPYING.RUNTIME \
        ${PREFIX}/share/licenses/gcc/RUNTIME.LIBRARY.EXCEPTION

mkdir -p $PREFIX/etc/conda/activate.d
echo "export CHOST=${CHOST}" | cat - $RECIPE_DIR/activate-gcc.sh > /tmp/out && mv /tmp/out $PREFIX/etc/conda/activate.d/activate-${PKG_NAME}.sh

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "export CHOST=${CHOST}" | cat - $RECIPE_DIR/deactivate-gcc.sh > /tmp/out && mv /tmp/out $PREFIX/etc/conda/deactivate.d/deactivate-${PKG_NAME}.sh
