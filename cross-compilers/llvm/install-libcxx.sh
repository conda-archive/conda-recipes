source activate ${PREFIX}

if [ $library_type == 'shared' ]; then
    libtype_flags=" -D LIBCXX_ENABLE_SHARED:BOOL=ON"
else
    $libtype_flags=" -D LIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=ON"
    $libtype_flags="$libtype_flags -D LIBCXX_ENABLE_SHARED:BOOL=OFF"
fi

# TODO: set C and CXX compiler to clang/clang++ - or else clang uses libstdc++
# these are created by the clang-
CC=$CLANG
CXX=$CLANGXX

# Install libc++
build=$SRCTOP/build-libcxx
rm -rf $build
mkdir -p $build
cd $build
unset CMAKE_FLAGS
CMAKE_FLAGS="$CMAKE_FLAGS -D CMAKE_INSTALL_PREFIX=$PREFIX/${cpu_arch}-${vendor}-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_PATH=$SRC_DIR/llvm"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_CXX_ABI=libcxxabi"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_CXX_ABI_INCLUDE_PATHS=$SRC_DIR/libcxxabi/include"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_BUILT_STANDALONE:BOOL=ON"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_TARGET_TRIPLE:STRING=${cpu_arch}-${vendor}-linux-gnu"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_SYSROOT:STRING=$PREFIX/${cpu_arch}-${vendor}-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_GCC_TOOLCHAIN:STRING=$PREFIX/bin"
CMAKE_FLAGS="$CMAKE_FLAGS $libtype_flags"
cmake -G "Unix Makefiles" $CMAKE_FLAGS $SRC_DIR/projects/libcxx
make -j${CPU_COUNT}
make install prefix="$PREFIX"
