source activate ${PREFIX}

cd $SRC_DIR/llvm_build

make prefix="$PREFIX" install

install -Dm644 LICENSE.TXT "$PREFIX/share/licenses/llvm/LICENSE"

# Install CMake stuff
install -d "${PREFIX}"/share/llvm/cmake/{modules,platforms}
install -Dm644 "${SRC_DIR}"/cmake/modules/*.cmake "${PREFIX}"/share/llvm/cmake/modules/
install -Dm644 "${SRC_DIR}"/cmake/platforms/*.cmake "${PREFIX}"/share/llvm/cmake/platforms/
