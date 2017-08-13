#!/bin/bash

VERBOSE_CM="VERBOSE=1"
VERBOSE_AT="V=1"

# Ensure we do not end up linking to a shared libz
rm -f "${PREFIX}"/lib/libz*${SHLIB_EXT}
# .. if this doesn't work we will need to pass LLVM_ENABLE_ZLIB
# or add find_library() to LLVM.

if [[ -f llvm_build_final/tools/cmake_install.cmake.orig ]]; then
  cp llvm_build_final/tools/cmake_install.cmake.orig tools/cmake_install.cmake
fi

if [[ -f llvm_build_final/projects/cmake_install.cmake.orig ]]; then
  cp llvm_build_final/projects/cmake_install.cmake.orig projects/cmake_install.cmake
fi

pushd cctools
  if [[ ! -f configure ]]; then
    autoreconf -vfi
    # Yuck, sorry.
    [[ -d include/macho-o ]] || mkdir -p include/macho-o
    cp ld64/src/other/prune_trie.h include/mach-o/prune_trie.h
    cp ld64/src/other/prune_trie.h libprunetrie/prune_trie.h
    cp ld64/src/other/PruneTrie.cpp libprunetrie/PruneTrie.cpp
  fi
popd

# We need to be careful to avoid linking to any shared libs.
# I have seen ncurses and zlib linked to the final binaries.
find ${PREFIX}/lib -name "*${SHLIB_EXT}"

# conda-build cleans out ${PREFIX} on each build. Also the sub-package install
# scripts need to selectively copy things across to ${PREFIX} from ${PWD}/prefix
# so we build to a different prefix and handle the copying manually. Because of
# this we need to tell the compilers to look in ${PREFIX} for our conda-package
# dependencies.
export LDFLAGS=${LDFLAGS}" -L${PREFIX}/lib"
export CFLAGS=${CFLAGS}" -I${PREFIX}/include"
export CXXFLAGS=${CXXFLAGS}" -I${PREFIX}/include"

OLD_PREFIX=${PREFIX}
PREFIX=${SRC_DIR}/prefix
# We want to stop using the bootstrap compiler so will remove it from PATH
# as soon as it's no longer necessary.
OLD_PATH=${PATH}

if [[ $(uname) == Linux ]]; then

  # Since we have ports of cctools and ld64 we can cross-compile.
  export MACOSX_DEPLOYMENT_TARGET=10.9
  # We do not need to use system compilers on Linux at all.
  _usr_bin_CC=${CC}
  _usr_bin_CXX=${CXX}
  # Nor do we need any special bootstrap compilers.
  BOOTSTRAP=${PREFIX}

elif [[ $(uname) == Darwin ]]; then

  BOOTSTRAP=${SRC_DIR}/bootstrap
  # Need to use a more modern clang to bootstrap the build.
  PATH=${BOOTSTRAP}/bin:${PATH}
  export CC=$(which clang)
  export CXX=$(which clang++)
  _usr_bin_CC=/usr/bin/clang
  _usr_bin_CXX=/usr/bin/clang++

  # Cannot set this when using CMake without also providing CMAKE_OSX_SYSROOT
  # (though that is not a bad idea really, if the SDK can be redistributed?).
  # unset MACOSX_DEPLOYMENT_TARGET
  export MACOSX_DEPLOYMENT_TARGET=10.9

  export CXXFLAGS=${CFLAGS}" -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
  export CFLAGS=${CFLAGS}" -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
  SYSROOT_DIR=${SRC_DIR}/bootstrap/MacOSX${MACOSX_DEPLOYMENT_TARGET}.sdk
  CFLAG_SYSROOT="--sysroot ${SYSROOT_DIR}"

fi

if [[ ${MACOSX_DEPLOYMENT_TARGET} == 10.9 ]]; then
  DARWIN_TARGET=x86_64-apple-darwin13.4.0
fi

if [[ -z ${DARWIN_TARGET} ]]; then
  echo "Need a valid DARWIN_TARGET"
  exit 1
fi

if [[ -n ${GCC} ]]; then
  CHOST=$(${GCC} -dumpmachine)
else
  CHOST=$(${CC} -dumpmachine)
fi

declare -a _cmake_config
_cmake_config+=(-DCMAKE_INSTALL_PREFIX:PATH=${PREFIX})
_cmake_config+=(-DCMAKE_BUILD_TYPE:STRING=Release)
# The bootstrap clang I use was built with a static libLLVMObject.a and I trying to get the same here
# _cmake_config+=(-DBUILD_SHARED_LIBS:BOOL=ON)
_cmake_config+=(-DLLVM_ENABLE_ASSERTIONS:BOOL=OFF)
_cmake_config+=(-DLINK_POLLY_INTO_TOOLS:BOOL=ON)
# Urgh, llvm *really* wants to link to ncurses / terminfo and I really do not want it to.
_cmake_config+=(-DHAVE_TERMINFO_CURSES=OFF)
# Sometimes these are reported as unused. Whatever.
_cmake_config+=(-DHAVE_TERMINFO_NCURSES=OFF)
_cmake_config+=(-DHAVE_TERMINFO_NCURSESW=OFF)
_cmake_config+=(-DHAVE_TERMINFO_TERMINFO=OFF)
_cmake_config+=(-DHAVE_TERMINFO_TINFO=OFF)
_cmake_config+=(-DHAVE_TERMIOS_H=OFF)
_cmake_config+=(-DCLANG_ENABLE_LIBXML=OFF)
_cmake_config+=(-DLIBOMP_INSTALL_ALIASES=OFF)
# Once we are using our libc++ (not until llvm_build_final), it will be single-arch only and not setting
# this causes link failures building the santizers since they respect DARWIN_osx_ARCHS. We may as well
# save some compilation time by setting this for all of our llvm builds.
_cmake_config+=(-DDARWIN_osx_ARCHS=x86_64)
# Only valid when using the Ninja Generator AFAICT
# _cmake_config+=(-DLLVM_PARALLEL_LINK_JOBS:STRING=1)
# What about cross-compiling targetting Darwin here? Are any of these needed?
if [[ $(uname) == Darwin ]]; then
  _cmake_config+=(-DCMAKE_OSX_SYSROOT=${SYSROOT_DIR})
  _cmake_config+=(-DDARWIN_macosx_CACHED_SYSROOT=${SYSROOT_DIR})
  _cmake_config+=(-DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET})
#elif [[ $(uname) == Linux ]]; then
#  _cmake_config+=(-DLLVM_BINUTILS_INCDIR=${PREFIX}/lib/gcc/${cpu_arch}-${vendor}-linux-gnu/${compiler_ver}/plugin/include)
fi

# For when the going gets tough:
# _cmake_config+=(-Wdev)
# _cmake_config+=(--debug-output)
# _cmake_config+=(--trace-expand)
# CPU_COUNT=1

declare -a _cctools_config
_cctools_config+=(--host=$(${CC} -dumpmachine))
_cctools_config+=(--build=$(${CC} -dumpmachine))
_cctools_config+=(--target=${DARWIN_TARGET})
_cctools_config+=(--prefix=${PREFIX})
_cctools_config+=(--disable-static)
_cctools_config+=(--enable-shared)

if [[ ! -f ${PREFIX}/bin/${DARWIN_TARGET}-ld ]]; then

  # libtool on macOS 10.9 is too old to build LLVM statically:
  # CMakeFiles/LLVMSupport.dir/PluginLoader.cpp.o is not an object file (not allowed in a library)
  # https://trac.macports.org/ticket/54129
  # .. so we must build a new one first. --without-llvm does not work here.
  if [[ $(uname) == Darwin ]]; then
    if [[ ! -e ${BOOTSTRAP}/bin/libtool${EXEEXT} ]]; then
      [[ -d cctools_build_libtool ]] || mkdir cctools_build_libtool
      pushd cctools_build_libtool
        # We cannot use bootstrap clang yet as configure fails with:
        # ld: unknown option: -no_deduplicate
        # We do however need a good libLTO.dylib and llvm-c/lto.h for
        # libstuff which is linked to libtool. Horrible.
        # .. you had better be running this on macOS 10.9 with the
        # .. compiler command line tools installed, otherwise YMMV
        CC=${_usr_bin_CC}" ${CFLAG_SYSROOT}"     \
        CXX=${_usr_bin_CXX}"  ${CFLAG_SYSROOT}"  \
          ../cctools/configure                   \
            "${_cctools_config[@]}"              \
            --prefix=${BOOTSTRAP}                \
            --with-llvm=${BOOTSTRAP}
      popd
      pushd cctools_build_libtool/libstuff
        make -j${CPU_COUNT} ${VERBOSE_AT}
      popd
      pushd cctools_build_libtool/misc
        make -j${CPU_COUNT} libtool${EXEEXT} ${VERBOSE_AT}
        cp libtool${EXEEXT} ${BOOTSTRAP}/bin
      popd
    fi
    BOOTSTRAP_LIBTOOL=${BOOTSTRAP}/bin/libtool
  else
    BOOTSTRAP_LIBTOOL=$(which libtool)
  fi

  if [[ ! -f ${PREFIX}/lib/libLTO${SHLIB_EXT} ]]; then
    [[ -d llvm_lto_build ]] || mkdir llvm_lto_build
    pushd llvm_lto_build
      cmake -G'Unix Makefiles'                        \
            "${_cmake_config[@]}"                     \
            -DCMAKE_LIBTOOL=${BOOTSTRAP_LIBTOOL}      \
            ..
      pushd tools/lto
        make -j${CPU_COUNT} ${VERBOSE_CM} install-LTO
      popd
    popd
    # TODO :: Tapi breaks when making cross-compilers.
    if [[ ! -f ${PREFIX}/lib/libtapi${SHLIB_EXT} ]]; then
      [[ -d llvm_tapi_build ]] || mkdir llvm_tapi_build
      pushd llvm_tapi_build
        cmake -G'Unix Makefiles'                                 \
              -C ../projects/tapi/cmake/caches/apple-tapi.cmake  \
              "${_cmake_config[@]}"                              \
              -DCMAKE_LIBTOOL=${BOOTSTRAP}/bin/libtool           \
              ..
        make -j${CPU_COUNT} ${VERBOSE_CM} install-distribution
      popd
    fi
  fi
  [[ -d cctools_build ]] || mkdir cctools_build
  pushd cctools_build
    # We still cannot use bootstrap clang yet as configure fails with:
    # ld: unknown option: -no_deduplicate
    # .. you had better be running this on macOS 10.9 with the
    # .. compiler command line tools installed, otherwise YMMV
    CC=${_usr_bin_CC}" ${CFLAG_SYSROOT}"    \
    CXX=${_usr_bin_CXX}" ${CFLAG_SYSROOT}"  \
      ../cctools/configure                  \
        "${_cctools_config[@]}"             \
        --prefix=${PREFIX}                  \
        --with-llvm=${PREFIX}
    make -j${CPU_COUNT} ${VERBOSE_AT}
    make install
  popd
fi

# Put our new cctools to the front of PATH, but also keep bootstrap.
export PATH=${PREFIX}/bin:${PATH}

if [[ ! -f llvm_build/bin/c-index-test ]]; then
  [[ -d llvm_build ]] || mkdir llvm_build
  pushd llvm_build
    CC=${CC}" ${CFLAG_SYSROOT}"                                                         \
    CXX=${CXX}" ${CFLAG_SYSROOT}"                                                       \
      cmake -G'Unix Makefiles'                                                          \
            "${_cmake_config[@]}"                                                       \
            -DCMAKE_LIBTOOL=${PREFIX}/bin/${DARWIN_TARGET}-libtool                      \
            -DLD64_EXECUTABLE=${PREFIX}/bin/${DARWIN_TARGET}-ld                         \
            -DCMAKE_INSTALL_NAME_TOOL=${PREFIX}/bin/${DARWIN_TARGET}-install_name_tool  \
            ..
    make -j${CPU_COUNT} ${VERBOSE_CM}
    make install
  popd
fi

# Now we have built llvm and clang, we rebuild cctools with them.
# Ditch the bootstrap compilers, we will use our own from now on.
export PATH=${PREFIX}/bin:${OLD_PATH}
if [[ ! -f cctools_build_final/ld64/ld ]]; then
  [[ -d cctools_build_final ]] || mkdir cctools_build_final
  pushd cctools_build_final
    CC=${PREFIX}/bin/clang" ${CFLAG_SYSROOT}"     \
    CXX=${PREFIX}/bin/clang++" ${CFLAG_SYSROOT}"  \
      ../cctools/configure                        \
        "${_cctools_config[@]}"                   \
        --prefix=${PREFIX}                        \
        --with-llvm=${PREFIX}
    make -j${CPU_COUNT} ${VERBOSE_AT}
    make install
  popd
fi

# Now we have built cctools with the new compilers rebuild clang
# with those. This is so that the libc++ they link to is not
# from /usr/lib but instead relative to our build prefix.
# We no longer need to use CFLAG_SYSROOT and can instead use:
export CONDA_BUILD_SYSROOT=${SYSROOT_DIR}
# .. to test that ld is behaving wrt CONDA_BUILD_SYSROOT, use command lines such as (old):
# prefix/bin/clang++ ~/hello-world.cpp --sysroot ~/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/bootstrap/MacOSX10.9.sdk -v -Wl,-t -Wl,-v
# vs (new):
# CONDA_BUILD_SYSROOT=~/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/bootstrap/MacOSX10.9.sdk prefix/bin/clang++ ~/hello-world.cpp -Wl,-t -Wl,-v
if [[ ! -f llvm_build_final/bin/c-index-test ]]; then
  [[ -d llvm_build_final ]] || mkdir llvm_build_final
  pushd llvm_build_final
    CC=${PREFIX}/bin/clang                                                              \
    CXX=${PREFIX}/bin/clang++                                                           \
      cmake -G'Unix Makefiles'                                                          \
            "${_cmake_config[@]}"                                                       \
            -DCMAKE_LIBTOOL=${PREFIX}/bin/${DARWIN_TARGET}-libtool                      \
            -DLD64_EXECUTABLE=${PREFIX}/bin/${DARWIN_TARGET}-ld                         \
            -DCMAKE_INSTALL_NAME_TOOL=${PREFIX}/bin/${DARWIN_TARGET}-install_name_tool  \
            ..
    make -j${CPU_COUNT} ${VERBOSE_CM}
    make install
  popd
fi

# Before running the install scripts, disable automatic installation of components that go into subpackages
# -i.orig to check what has been removed in-case it starts dropping more than it should
# and so we can undo this on re-entry.
#

if sed --help 2>&1 | grep GNU > /dev/null; then
  SED="sed -r"
else
  SED="sed -E"
fi

${SED} -i.orig '/\/clang|lld|lldb|polly\/cmake_install.cmake/d' llvm_build_final/tools/cmake_install.cmake
${SED} -i.orig '/\/compiler-rt|libcxxabi|libcxx|libunwind|openmp|tapi\/cmake_install.cmake/d' llvm_build_final/projects/cmake_install.cmake


# There is no way of having libc++.dylib instruct the linker to add a relative rpath, though that would be nice.
#
# We could rewrite the LC_ID_DYLIB at install time when building but that would be horrible. The code involved is:
#   cctools/ld64/src/ld/HeaderAndLoadCommands.hpp line 1346 (uint8_t* HeaderAndLoadCommandsAtom<A>::copyDylibLoadCommand(uint8_t* p, const ld::dylib::File* dylib) const)
# and:
#   cctools/ld64/src/ld/parsers/macho_dylib_file.cpp line 162 (case LC_ID_DYLIB)
#
# Instead, LLVM for example uses:
# set(_install_rpath "@loader_path/../lib" ${extra_libdir})
# set_target_properties(${name} PROPERTIES
# set_target_properties(${name} PROPERTIES
#                       BUILD_WITH_INSTALL_RPATH On
#                       INSTALL_RPATH "${_install_rpath}"
#                       ${_install_name_dir})
#
# References for how Apple's dynamic loader works:
#
# https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/RunpathDependentLibraries.html#//apple_ref/doc/uid/TP40008306-SW1
# https://raw.githubusercontent.com/opensource-apple/dyld/master/src/ImageLoaderMachO.cpp (search for @loader_path and @executable_path).
#
# To iterate on clang/clang++ frontend changes, edit for example:
# /Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/tools/clang/lib/Frontend/InitHeaderSearch.cpp

