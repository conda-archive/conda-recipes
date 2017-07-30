#!/bin/bash

set -x

mkdir -p llvm_build
if [[ -n ${GCC} ]]; then
  CHOST=$(${GCC} -dumpmachine)
else
  CHOST=$(clang -dumpmachine)
fi

if [[ $(uname) == Darwin ]]; then
  # Cannot set this when using CMake without also providing CMAKE_OSX_SYSROOT
  # (though that is not a bad idea really, if the SDK can be redistributed).
  unset MACOSX_DEPLOYMENT_TARGET
  export MACOSX_DEPLOYMENT_TARGET
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
    if [[ $(uname) == Darwin ]]; then
      CMAKE_FLAGS="$CMAKE_FLAGS -D CMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}"
    fi
    # CMAKE_FLAGS="$CMAKE_FLAGS -Wdev --debug-output --trace"
    # I think this is for gold - which Ray says we need MOSTLY_STATIC support in gcc for
    # CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_BINUTILS_INCDIR=$PREFIX/lib/gcc/${cpu_arch}-${vendor}-linux-gnu/${compiler_ver}/plugin/include"
#    cmake -G "Unix Makefiles" $CMAKE_FLAGS ..


# -D CMAKE_BUILD_TYPE:STRING=Release \
# -D CMAKE_INSTALL_PREFIX:PATH=/Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/_h_env_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_plac \
# -DLINK_POLLY_INTO_TOOLS:BOOL=ON \
# -D LLVM_PARALLEL_LINK_JOBS:STRING=1 \
# -D BUILD_SHARED_LIBS:BOOL=ON \
# -D LLVM_ENABLE_ASSERTIONS:BOOL=ON \
# -D CMAKE_OSX_DEPLOYMENT_TARGET= \

    cmake -G 'Unix Makefiles' \
      ..
    make -j${CPU_COUNT} VERBOSE=1
    popd
fi
