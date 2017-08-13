set -e -x

CHOST=$(${SRC_DIR}/.build/*-*-*-*/build/build-cc-gcc-final/gcc/xgcc -dumpmachine)
_libdir=libexec/gcc/${CHOST}/${PKG_VERSION}

# libtool wants to use ranlib that is here, macOS install doesn't grok -t etc
# .. do we need this scoped over the whole file though?
export PATH=${SRC_DIR}/gcc_built/bin:${SRC_DIR}/.build/${CHOST}/buildtools/bin:${SRC_DIR}/.build/tools/bin:${PATH}

pushd ${SRC_DIR}/.build/$CHOST/build/build-cc-gcc-final/

make -C gcc prefix=${PREFIX} c++.install-common install-lto-wrapper
make -C lto-plugin prefix=${PREFIX} install
install -dm755 ${PREFIX}/lib/bfd-plugins/

# statically linked, so this so does not exist
# ln -s $PREFIX/lib/gcc/$CHOST/liblto_plugin.so ${PREFIX}/lib/bfd-plugins/

# How it used to be:
# install -m755 -t ${PREFIX}/bin/ gcc/{cc1plus,lto1}
for file in cc1plus; do
  if [[ -f gcc/${file} ]]; then
    install -c gcc/${file} ${PREFIX}/${_libdir}/${file}
  fi
done

make -C $CHOST/libstdc++-v3/src prefix=${PREFIX} install
make -C $CHOST/libstdc++-v3/include prefix=${PREFIX} install
make -C $CHOST/libstdc++-v3/libsupc++ prefix=${PREFIX} install
make -C $CHOST/libstdc++-v3/python prefix=${PREFIX} install

# Probably don't want to do this for cross-compilers
# mkdir -p ${PREFIX}/share/gdb/auto-load/usr/lib/
# cp ${SRC_DIR}/gcc_built/${CHOST}/sysroot/lib/libstdc++.so.6.*-gdb.py ${PREFIX}/share/gdb/auto-load/usr/lib/

make -C libcpp prefix=${PREFIX} install

popd

mkdir -p ${PREFIX}/etc/conda/{de,}activate.d
cp "${SRC_DIR}"/activate-g++.sh ${PREFIX}/etc/conda/activate.d/activate-${PKG_NAME}.sh
cp "${SRC_DIR}"/deactivate-g++.sh ${PREFIX}/etc/conda/deactivate.d/deactivate-${PKG_NAME}.sh

# Test:
${PREFIX}/bin/${CHOST}-g++ "${RECIPE_DIR}"/hello-world.cpp
