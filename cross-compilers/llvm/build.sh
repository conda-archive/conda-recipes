mkdir -p llvm_build
if [[ -n ${GCC} ]]; then
  CHOST=$(${GCC} -dumpmachine)
else
  CHOST=$(clang -dumpmachine)
fi

if [[ ! -e "${SRC_DIR}/llvm_build/tools/clang/tools/c-index-test" ]]; then
    pushd llvm_build
    # TODO: how to add AArch64 here based on conda_build_config.yaml - does case matter?
    CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_TARGETS_TO_BUILD:STRING=X86;AArch64"
    CMAKE_FLAGS="$CMAKE_FLAGS -D CMAKE_BUILD_TYPE:STRING=Release"
    CMAKE_FLAGS="$CMAKE_FLAGS -D CMAKE_INSTALL_PREFIX:PATH=$PREFIX"
    CMAKE_FLAGS="$CMAKE_FLAGS ${SNAPSHOT_MINIMAL:- -DLINK_POLLY_INTO_TOOLS:BOOL=ON}"
    CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_PARALLEL_LINK_JOBS:STRING=1"
    CMAKE_FLAGS="$CMAKE_FLAGS -D BUILD_SHARED_LIBS:BOOL=ON"
    CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_ENABLE_ASSERTIONS:BOOL=ON"
    # I think this is for gold - which Ray says we need MOSTLY_STATIC support in gcc for
    # CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_BINUTILS_INCDIR=$PREFIX/lib/gcc/${cpu_arch}-${vendor}-linux-gnu/${compiler_ver}/plugin/include"
    cmake -G "Unix Makefiles" $CMAKE_FLAGS ..
    make -j${CPU_COUNT}
    popd
fi
