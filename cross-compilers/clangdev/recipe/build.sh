mkdir -p build
cd build

cmake -G "Unix Makefiles" -D LLVM_TARGETS_TO_BUILD:STRING="X86;AArch64" \
            -D CMAKE_BUILD_TYPE:STRING=$BUILD_TYPE \
            -D CMAKE_INSTALL_$PREFIX:PATH=$PREFIX \
            ${SNAPSHOT_MINIMAL:- -DLINK_POLLY_INTO_TOOLS:BOOL=ON} \
            -D LLVM_PARALLEL_LINK_JOBS:STRING=1 \
            -D BUILD_SHARED_LIBS:BOOL=ON \
            -D LLVM_ENABLE_ASSERTIONS:BOOL=ON \
            -DLLVM_BINUTILS_INCDIR=$PREFIX/lib/gcc/aarch64-sarc-linux-gnu/5.3.0/plugin/include \
            ${SRC_DIR}/llvm &> $PREFIX/cmake.log
make install &> $PREFIX/install.log

export CC=$PREFIX/bin/aarch64-linux-clang
export CXX=$PREFIX/bin/aarch64-linux-clang++

unset CMAKE_FLAGS
CMAKE_FLAGS="$CMAKE_FLAGS" -D
CMAKE_INSTALL_PREFIX="$PREFIX/aarch64-sarc-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_PATH=$$PREFIX/llvm"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXXABI_LIBCXX_PATH=$SRCTOP/libcxx"
cmake -G Ninja $CMAKE_FLAGS $SRCTOP/libcxxabi >> $PREFIX/cmake.log 2>&1
ninja >> $PREFIX/ninja.log 2>&1
ninja install >> $PREFIX/install.log 2>&1

build=$SRCTOP/ninja-libcxx
rm -rf $build
mkdir -p $build
cd $build
unset CMAKE_FLAGS
CMAKE_FLAGS="$CMAKE_FLAGS -D"
CMAKE_INSTALL_PREFIX="$PREFIX/aarch64-sarc-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_PATH=$SRCTOP/llvm"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_CXX_ABI=libcxxabi"
CMAKE_FLAGS="$CMAKE_FLAGS -D"
LIBCXX_CXX_ABI_INCLUDE_PATHS="$SRCTOP/libcxxabi/include"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_BUILT_STANDALONE:BOOL=ON"
CMAKE_FLAGS="$CMAKE_FLAGS -D"
LIBCXX_TARGET_TRIPLE:"STRING=aarch64-sarc-linux-gnu"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_ENABLE_SHARED:BOOL=ON"
CMAKE_FLAGS="$CMAKE_FLAGS -D"
LIBCXX_SYSROOT:STRING="$PREFIX/aarch64-sarc-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_GCC_TOOLCHAIN:STRING=$PREFIX/bin"
cmake -G Ninja $CMAKE_FLAGS $SRCTOP/libcxx >> $PREFIX/cmake.log
ninja >> $PREFIX/ninja.log 2>&1
ninja install >> $PREFIX/install.log 2>&1

build=\$SRCTOP/ninja-libcxx
rm -rf \$build
mkdir -p \$build
cd \$build
unset CMAKE_FLAGS
CMAKE_FLAGS="$CMAKE_FLAGS -D"
CMAKE_INSTALL_PREFIX="$PREFIX/aarch64-sarc-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -D LLVM_PATH=$SRCTOP/llvm"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_CXX_ABI=libcxxabi"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_CXX_ABI_INCLUDE_PATHS=$SRCTOP/libcxxabi/include"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_BUILT_STANDALONE:BOOL=ON"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_TARGET_TRIPLE:STRING=aarch64-sarc-linux-gnu"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=ON"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_ENABLE_SHARED:BOOL=OFF"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_SYSROOT:STRING=$PREFIX/aarch64-sarc-linux-gnu/sysroot"
CMAKE_FLAGS="$CMAKE_FLAGS -D LIBCXX_GCC_TOOLCHAIN:STRING=$PREFIX/bin"
cmake -G Ninja $CMAKE_FLAGS $SRCTOP/libcxx >> $PREFIX/cmake.log 2>&1
ninja >> $PREFIX/ninja.log 2>&1
ninja install >> $PREFIX/install.log 2>&1


make -j${CPU_COUNT}
make install
