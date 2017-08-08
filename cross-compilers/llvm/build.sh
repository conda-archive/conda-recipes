#!/bin/bash

if [[ $(uname) == Linux ]]; then
  # Since we have ports of cctools and ld64 we can cross-compile.
  export MACOSX_DEPLOYMENT_TARGET=10.9
elif [[ $(uname) == Darwin ]]; then

  BOOTSTRAP=${PWD}/bootstrap
  # Need to use a more modern clang to bootstrap the build.
  PATH=${BOOTSTRAP}/bin:${PATH}
  export CC=$(which clang)
  export CXX=$(which clang++)

  # Cannot set this when using CMake without also providing CMAKE_OSX_SYSROOT
  # (though that is not a bad idea really, if the SDK can be redistributed?).
  # unset MACOSX_DEPLOYMENT_TARGET
  export MACOSX_DEPLOYMENT_TARGET=10.9

  export CXXFLAGS=-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}
  export CFLAGS=-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}
  SYSROOT_DIR=${SRC_DIR}/bootstrap/MacOSX${MACOSX_DEPLOYMENT_TARGET}.sdk
  CFLAG_SYSROOT="--sysroot ${SYSROOT_DIR}"

  # Still having trouble with atomics in tsan:
  # [ 27%] Building CXX object projects/compiler-rt/lib/tsan/CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_interceptors_mac.cc.o
  # cd /Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/llvm_build/projects/compiler-rt/lib/tsan && /Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/bootstrap/bin/clang++   -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -Dclang_rt_tsan_osx_dynamic_EXPORTS -I/Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/llvm_build/projects/compiler-rt/lib/tsan -I/Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/projects/compiler-rt/lib/tsan -I/Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/llvm_build/include -I/Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/include -I/Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/projects/compiler-rt/lib/tsan/..  -arch x86_64  -fPIC -fvisibility-inlines-hidden -Wall -W -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wcovered-switch-default -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wstring-conversion -Werror=date-time -std=c++11 -Wall -std=c++11 -Wno-unused-parameter -g -arch x86_64 -fPIC    -stdlib=libc++ -mmacosx-version-min=10.9 -isysroot / -fPIC -fno-builtin -fno-exceptions -fomit-frame-pointer -funwind-tables -fno-stack-protector -fno-sanitize=safe-stack -fvisibility=hidden -fvisibility-inlines-hidden -fno-function-sections -fno-lto -O3 -gline-tables-only -Wno-gnu -Wno-variadic-macros -Wno-c99-extensions -Wno-non-virtual-dtor -fPIE -fno-rtti -msse3 -Wframe-larger-than=530 -Wglobal-constructors -o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_interceptors_mac.cc.o -c /Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/projects/compiler-rt/lib/tsan/rtl/tsan_interceptors_mac.cc
  # /Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/bootstrap/bin/clang++   -arch x86_64  -fPIC -fvisibility-inlines-hidden -Wall -W -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wcovered-switch-default -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wstring-conversion -Werror=date-time -std=c++11 -Wall -std=c++11 -Wno-unused-parameter -g -arch x86_64 -dynamiclib -Wl,-headerpad_max_install_names  -stdlib=libc++ -lc++ -lc++abi -fapplication-extension -mmacosx-version-min=10.9 -isysroot / -Wl,-U,___ubsan_default_options -Wl,-U,___sanitizer_free_hook -Wl,-U,___sanitizer_malloc_hook -Wl,-U,___sanitizer_symbolize_code -Wl,-U,___sanitizer_symbolize_data -Wl,-U,___sanitizer_symbolize_demangle -Wl,-U,___sanitizer_symbolize_flush   -arch x86_64 -o ../../../../lib/clang/4.0.1/lib/darwin/libclang_rt.tsan_osx_dynamic.dylib -install_name @rpath/libclang_rt.tsan_osx_dynamic.dylib CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_clock.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_debugging.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_fd.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_flags.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_ignoreset.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_interceptors.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_interface.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_interface_ann.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_interface_atomic.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_interface_java.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_malloc_mac.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_md5.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_mman.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_mutex.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_mutexset.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_preinit.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_report.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_rtl.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_rtl_mutex.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_rtl_proc.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_rtl_report.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_rtl_thread.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_stack_trace.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_stat.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_suppressions.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_symbolize.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_sync.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_interceptors_mac.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_libdispatch_mac.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_platform_mac.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_platform_posix.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_new_delete.cc.o CMakeFiles/clang_rt.tsan_osx_dynamic.dir/rtl/tsan_rtl_amd64.S.o ../interception/CMakeFiles/RTInterception.osx.dir/interception_linux.cc.o ../interception/CMakeFiles/RTInterception.osx.dir/interception_mac.cc.o ../interception/CMakeFiles/RTInterception.osx.dir/interception_win.cc.o ../interception/CMakeFiles/RTInterception.osx.dir/interception_type_test.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_allocator.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_common.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_deadlock_detector1.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_deadlock_detector2.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_flags.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_flag_parser.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_libc.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_libignore.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_linux.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_linux_s390.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_mac.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_persistent_allocator.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_platform_limits_linux.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_platform_limits_posix.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_posix.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_printf.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_procmaps_common.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_procmaps_freebsd.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_procmaps_linux.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_procmaps_mac.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_stackdepot.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_stacktrace.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_stacktrace_printer.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_suppressions.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_symbolizer.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_symbolizer_libbacktrace.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_symbolizer_mac.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_symbolizer_win.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_tls_get_addr.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_thread_registry.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_win.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommon.osx.dir/sanitizer_termination.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_common_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sancov_flags.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_coverage_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_coverage_libcdep_new.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_coverage_mapping_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_linux_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_posix_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_stacktrace_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_stoptheworld_linux_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_symbolizer_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_symbolizer_posix_libcdep.cc.o ../sanitizer_common/CMakeFiles/RTSanitizerCommonLibc.osx.dir/sanitizer_unwind_linux_libcdep.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_diag.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_init.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_flags.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_handlers.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_value.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_handlers_cxx.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_type_hash.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_type_hash_itanium.cc.o ../ubsan/CMakeFiles/RTUbsan.osx.dir/ubsan_type_hash_win.cc.o
  # ld: warning: linking against dylib not safe for use in application extensions: /usr/lib/libc++.dylib
  # ld: warning: linking against dylib not safe for use in application extensions: /usr/lib/libc++abi.dylib
  # ld: warning: linking against dylib not safe for use in application extensions: /usr/lib/libSystem.dylib
  # Undefined symbols for architecture x86_64:
  #   "_OSAtomicDecrement32", referenced from:
  #       _wrap_OSAtomicDecrement32 in tsan_interceptors_mac.cc.o
  #       __tsan::substitution_OSAtomicDecrement32 in tsan_interceptors_mac.cc.o
  #      (maybe you meant: _wrap_OSAtomicDecrement32Barrier, _wrap_OSAtomicDecrement32 )
  #   "_OSAtomicDecrement32Barrier", referenced from:
  #       _wrap_OSAtomicDecrement32Barrier in tsan_interceptors_mac.cc.o
  #       __tsan::substitution_OSAtomicDecrement32Barrier in tsan_interceptors_mac.cc.o
  #      (maybe you meant: _wrap_OSAtomicDecrement32Barrier)
  #   "_OSAtomicDecrement64", referenced from:
  #       _wrap_OSAtomicDecrement64 in tsan_interceptors_mac.cc.o
  #       __tsan::substitution_OSAtomicDecrement64 in tsan_interceptors_mac.cc.o
  #      (maybe you meant: _wrap_OSAtomicDecrement64, _wrap_OSAtomicDecrement64Barrier )
  #   "_OSAtomicDecrement64Barrier", referenced from:
  #       _wrap_OSAtomicDecrement64Barrier in tsan_interceptors_mac.cc.o
  #       __tsan::substitution_OSAtomicDecrement64Barrier in tsan_interceptors_mac.cc.o
  #      (maybe you meant: _wrap_OSAtomicDecrement64Barrier)
  #   "_OSAtomicIncrement32", referenced from:
  #       _wrap_OSAtomicIncrement32 in tsan_interceptors_mac.cc.o
  #       __tsan::substitution_OSAtomicIncrement32 in tsan_interceptors_mac.cc.o
  #      (maybe you meant: _wrap_OSAtomicIncrement32, _wrap_OSAtomicIncrement32Barrier )
  #   "_OSAtomicIncrement32Barrier", referenced from:
  #       _wrap_OSAtomicIncrement32Barrier in tsan_interceptors_mac.cc.o
  #       __tsan::substitution_OSAtomicIncrement32Barrier in tsan_interceptors_mac.cc.o
  #      (maybe you meant: _wrap_OSAtomicIncrement32Barrier)
  #   "_OSAtomicIncrement64", referenced from:
  #       _wrap_OSAtomicIncrement64 in tsan_interceptors_mac.cc.o
  #       __tsan::substitution_OSAtomicIncrement64 in tsan_interceptors_mac.cc.o
  #      (maybe you meant: _wrap_OSAtomicIncrement64, _wrap_OSAtomicIncrement64Barrier )
  #   "_OSAtomicIncrement64Barrier", referenced from:
  #       _wrap_OSAtomicIncrement64Barrier in tsan_interceptors_mac.cc.o
  #       __tsan::substitution_OSAtomicIncrement64Barrier in tsan_interceptors_mac.cc.o
  #      (maybe you meant: _wrap_OSAtomicIncrement64Barrier)
  # ld: symbol(s) not found for architecture x86_64
fi

if [[ ${MACOSX_DEPLOYMENT_TARGET} == 10.9 ]]; then
  DARWIN_TARGET=x86_64-apple-darwin13.4.0
fi

if [[ -n ${GCC} ]]; then
  CHOST=$(${GCC} -dumpmachine)
else
  CHOST=$(${CC} -dumpmachine)
fi

# conda-build cleans out ${PREFIX} on each build. Also the sub-package install
# scripts need to copy things across to ${PREFIX} from ${PWD}/prefix
OLD_PREFIX=${PREFIX}
PREFIX=${PWD}/prefix

declare -a _cmake_config
_cmake_config+=(-DCMAKE_INSTALL_PREFIX:PATH=${PREFIX})
# TODO: how to add AArch64 here based on conda_build_config.yaml - does case matter?
# _cmake_config+=(-DLLVM_TARGETS_TO_BUILD:STRING=X86;AArch64)
_cmake_config+=(-DCMAKE_BUILD_TYPE:STRING=Release)
# The bootstrap clang I use was built with a static libLLVMObject.a and I trying to get the same here
# _cmake_config+=(-DBUILD_SHARED_LIBS:BOOL=ON)
_cmake_config+=(-DLLVM_ENABLE_ASSERTIONS:BOOL=OFF)
_cmake_config+=(-DLINK_POLLY_INTO_TOOLS:BOOL=ON)
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

if [[ ! -f ${PREFIX}/bin/otool ]]; then

  pushd cctools
    autoreconf -vfi
      # Yuck, sorry.
      [[ -d include/macho-o ]] || mkdir -p include/macho-o
      cp ld64/src/other/prune_trie.h include/mach-o/prune_trie.h
      cp ld64/src/other/prune_trie.h libprunetrie/prune_trie.h
      cp ld64/src/other/PruneTrie.cpp libprunetrie/PruneTrie.cpp
  popd

  # libtool on macOS 10.9 is too old to build LLVM statically:
  # CMakeFiles/LLVMSupport.dir/PluginLoader.cpp.o is not an object file (not allowed in a library)
  # https://trac.macports.org/ticket/54129
  # .. so we must build a new one first.
  if [[ ! -e ${BOOTSTRAP}/bin/libtool${EXEEXT} ]]; then
    [[ -d cctools_build_libtool ]] || mkdir cctools_build_libtool
    pushd cctools_build_libtool
      # We cannot use bootstrap clang yet as configure fails with:
      # ld: unknown option: -no_deduplicate
      # .. you had better be running this on macOS 10.9 with the
      # .. compiler command line tools installed, otherwise YMMV
      CC=/usr/bin/clang" ${CFLAG_SYSROOT}"     \
      CXX=/usr/bin/clang++" ${CFLAG_SYSROOT}"  \
        ../cctools/configure                   \
          "${_cctools_config[@]}"              \
          --prefix=${BOOTSTRAP}                \
          --with-llvm=${BOOTSTRAP}             \
          --disable-static
    popd
    pushd cctools_build_libtool/libstuff
      make -j${CPU_COUNT}
    popd
    pushd cctools_build_libtool/misc
      make -j${CPU_COUNT} libtool${EXEEXT}
      cp libtool${EXEEXT} ${BOOTSTRAP}/bin
    popd
  fi

  if [[ ! -e ${PREFIX}/lib/libLTO${SHLIB_EXT} ]]; then
    [[ -d llvm_lto_build ]] || mkdir llvm_lto_build
    pushd llvm_lto_build
      cmake -G'Unix Makefiles'                        \
            "${_cmake_config[@]}"                     \
            -DCMAKE_LIBTOOL=${BOOTSTRAP}/bin/libtool  \
            ..
      pushd tools/lto
        make -j${CPU_COUNT} install-LTO
      popd
      # popd
    popd
    if [[ ! -e ${PREFIX}/lib/libtapi${SHLIB_EXT} ]]; then
      [[ -d llvm_tapi_build ]] || mkdir llvm_tapi_build
      pushd llvm_tapi_build
        # _cmake_config+=(-Wdev)
        # _cmake_config+=(--debug-output)
        # _cmake_config+=(--trace-expand)
        cmake -G'Unix Makefiles'                                 \
              -C ../projects/tapi/cmake/caches/apple-tapi.cmake  \
              "${_cmake_config[@]}"                              \
              -DCMAKE_LIBTOOL=${BOOTSTRAP}/bin/libtool           \
              ..
        make -j${CPU_COUNT} install-distribution
        # tapi will fail to build here as it will not link to two libs, one of which has been built this time around (LLVMSupport)
        # and one of which has not, LLVMObject (but it has been built by install-LTO, as a dylib whereas the official releases are
        # static).
        # To reproduce the failure:
        # pushd /Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/llvm_tapi_build/projects/tapi/lib/Core
        # /Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/bootstrap/bin/clang++  -mmacosx-version-min=10.9  -stdlib=libc++ -fPIC -fvisibility-inlines-hidden -Wall -W -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wcovered-switch-default -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wstring-conversion -Werror=date-time -std=c++11 -flto -Os    -DNDEBUG -isysroot /Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/bootstrap/MacOSX10.9.sdk -mmacosx-version-min=10.9 -dynamiclib -Wl,-headerpad_max_install_names  -Wl,-dead_strip -Wl,-object_path_lto,/Users/vagrant/conda/automated-build/bootstrap/mcf-x-build/cross-compiler/work/llvm_tapi_build/projects/tapi/lib/Core/./tapiCore-lto.o   -arch x86_64 -stdlib=libc++ -flto -o ../../../../lib/libtapiCore.dylib -install_name @rpath/libtapiCore.dylib CMakeFiles/tapiCore.dir/ArchitectureSupport.cpp.o CMakeFiles/tapiCore.dir/InterfaceFile.cpp.o CMakeFiles/tapiCore.dir/MachODylibReader.cpp.o CMakeFiles/tapiCore.dir/Registry.cpp.o CMakeFiles/tapiCore.dir/Symbol.cpp.o CMakeFiles/tapiCore.dir/TextStub_v1.cpp.o CMakeFiles/tapiCore.dir/TextStub_v2.cpp.o CMakeFiles/tapiCore.dir/YAMLReaderWriter.cpp.o -Wl,-rpath,@loader_path/../lib
        # To work around it, add:
        # -L../../../../lib/ -lLLVMSupport -L../../../../../llvm_lto_build/lib -lLLVMObject
        # Overall, combining this in the same build as install-LTO might be wise? I am not sure if llvm-config would help with any of this too?
      popd
    fi
  fi
  [[ -d cctools_build ]] || mkdir cctools_build
  pushd cctools_build
    # We still cannot use bootstrap clang yet as configure fails with:
    # ld: unknown option: -no_deduplicate
    # .. you had better be running this on macOS 10.9 with the
    # .. compiler command line tools installed, otherwise YMMV
    CC=/usr/bin/clang" ${CFLAG_SYSROOT}"     \
    CXX=/usr/bin/clang++" ${CFLAG_SYSROOT}"  \
      ../cctools/configure                   \
        "${_cctools_config[@]}"              \
        --prefix=${PREFIX}                   \
        --with-llvm=${PREFIX}                \
        --disable-static
    make -j${CPU_COUNT} VERBOSE=1
    make install
  popd
fi

if [[ ! -e "${SRC_DIR}/llvm_build/tools/clang/tools/c-index-test" ]]; then
  [[ -d llvm_build ]] || mkdir llvm_build
  pushd llvm_build
     cmake -G'Unix Makefiles'                      \
            "${_cmake_config[@]}"                  \
            -DCMAKE_LIBTOOL=${PREFIX}/bin/libtool  \
            -DLD64_EXECUTABLE=${PREFIX}/bin/ld64   \
            ..
      make -j${CPU_COUNT} V=1
      make install
  popd
fi
