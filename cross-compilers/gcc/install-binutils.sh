set -e -x

CHOST="x86_64-${vendor}-linux-gnu"
PACKAGE="binutils"

# libtool wants to use ranlib that is here
export PATH=$PATH:${SRC_DIR}/.build/$CHOST/buildtools/bin

pushd $SRC_DIR/.build/$CHOST/build/build-binutils-host-x86_64-build_redhat-linux-gnu6E
make prefix=$PREFIX install
popd

mkdir -p $PREFIX/etc/conda/activate.d
echo "export CHOST=${CHOST}" | cat - $RECIPE_DIR/activate-${PACKAGE}.sh > /tmp/out && mv /tmp/out $PREFIX/etc/conda/activate.d/activate-${PACKAGE}-${CHOST}.sh

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "export CHOST=${CHOST}" | cat - $RECIPE_DIR/deactivate-${PACKAGE}.sh > /tmp/out && mv /tmp/out $PREFIX/etc/conda/deactivate.d/deactivate-${PACKAGE}-${CHOST}.sh
