source activate ${PREFIX}

cd $SRC_DIR/llvm_build/tools/clang
make prefix="$PREFIX" install
