source activate ${PREFIX}

export CC=$CLANG
export CXX=$CLANGXX

build=$SRC_DIR/build-libcxxabi
rm -rf $build
mkdir -p $build
cd $build
unset CMAKE_FLAGS
CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_INSTALL_PREFIX=$PREFIX/${cpu_arch}-${vendor}-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_PATH=$SRC_DIR/llvm"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXXABI_LIBCXX_PATH=$SRC_DIR/libcxx"
cmake -G "Unix Makefiles" $CMAKE_FLAGS $SRC_DIR/projects/libcxxabi
make -j${CPU_COUNT}
make install prefix=$PREFIX
