set -e -x
CHOST="x86_64-sarc-linux-gnu"
# libtool wants to use ranlib that is here
export PATH=$PATH:${SRC_DIR}/.build/$CHOST/buildtools/bin

pushd $SRC_DIR/.build/$CHOST/build/build-binutils-host-x86_64-build_redhat-linux-gnu6E
make prefix=$PREFIX install
popd

mkdir -p $PREFIX/etc/conda/activate.d
cp $RECIPE_DIR/activate-binutils.sh $PREFIX/etc/conda/activate.d/compiler_linux-cos5-64-activate-binutils.sh

mkdir -p $PREFIX/etc/conda/deactivate.d
cp $RECIPE_DIR/deactivate-binutils.sh $PREFIX/etc/conda/deactivate.d/compiler_linux-cos5-64-deactivate-binutils.sh
