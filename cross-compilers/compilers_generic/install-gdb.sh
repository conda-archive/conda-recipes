set -e -x

CHOST=$(${SRC_DIR}/.build/*-*-*-*/build/build-cc-gcc-final/gcc/xgcc -dumpmachine)

# libtool wants to use ranlib that is here
# for psuedo-cross, depending on the build and host,
# build-gdb-native could be used (it will have been built
# with the newer GCC instead of the system one).
pushd ${SRC_DIR}/.build/${CHOST}/build/build-gdb-cross
  PATH=${SRC_DIR}/.build/${CHOST}/buildtools/bin:$PATH \
  make prefix=${PREFIX} install
  # Gets installed by binutils:
  rm ${PREFIX}/share/info/bfd.info
popd
