source activate ${PREFIX}

TRIPLE=${cpu_arch}-${vendor}-linux-gnu

cat <<EOF > $PREFIX/bin/$TRIPLE-clang
#!/bin/bash

# We are building LLVM with DSOs, LD_LIBRARY_PATH is needed for libstdc++.so.
LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/clang \
    --target=$TRIPLE \
    --sysroot=$PREFIX/$TRIPLE/sysroot "\$@"
EOF

chmod +x $PREFIX/bin/$TRIPLE-clang

cat <<EOF > $PREFIX/bin/$TRIPLE-clang++
#!/bin/bash

# We are building LLVM with DSOs, LD_LIBRARY_PATH is needed for libstdc++.so.
LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH $PREFIX/bin/clang++ \
    --target=$TRIPLE \
    --sysroot=$PREFIX/$TRIPLE/sysroot \
    -cxx-isystem $PREFIX/$TRIPLE/c++/${compiler_ver} \
    -cxx-isystem $PREFIX/$TRIPLE/include/c++/${compiler_ver}/$TRIPLE "\$@"
EOF

chmod +x $PREFIX/bin/$TRIPLE-clang++

mkdir -p $PREFIX/etc/conda/activate.d
cat <<EOF > $PREFIX/etc/conda/activate.d/activate_clang_${TRIPLE}.sh
export CLANG=$PREFIX/bin/$TRIPLE-clang
export CLANGXX=$PREFIX/bin/$TRIPLE-clang++
EOF
