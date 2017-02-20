set -e -x

pushd $SRC_DIR/.build/x86_64-sarc-linux-gnu/build/build-binutils-host-x86_64-build_redhat-linux-gnu6E
make DESTDIR=$PREFIX install
popd

# since binutils is a req for all compilers, we bundle the activate scripts here.
mkdir -p $PREFIX/etc/conda/activate.d
cp $RECIPE_DIR/activate.sh $PREFIX/etc/conda/activate.d/compiler_linux-64_linux-cos5-64-activate.sh

mkdir -p $PREFIX/etc/conda/deactivate.d
cp $RECIPE_DIR/deactivate.sh $PREFIX/etc/conda/deactivate.d/compiler_linux-64_linux-cos5-64-deactivate.sh
