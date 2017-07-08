source activate ${PREFIX}

export CC=$CLANG
export CXX=$CLANGXX

build=$SRC_DIR/build-compiler-rt
rm -rf $build
mkdir -p $build
cd $build
unset CMAKE_FLAGS
CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_INSTALL_PREFIX=$PREFIX/${cpu_arch}-${vendor}-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -DLLVM_CONFIG_PATH=$PREFIX/bin/llvm-config"
cmake -G "Unix Makefiles" $CMAKE_FLAGS $SRC_DIR/projects/compiler-rt
make -j${CPU_COUNT}
make install prefix=$PREFIX
