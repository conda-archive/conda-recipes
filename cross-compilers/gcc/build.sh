echo $(pwd)
mkdir -p .build/src
mkdir -p .build/tarballs
if [[ ! -e ".build/tarballs/linux-2.6.18.tar.xz" ]]; then
    curl -L https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.18.tar.xz -o $(pwd)/.build/tarballs/linux-2.6.18.tar.xz;
fi

cp $RECIPE_DIR/.config .config

# If dirty is unset or the binary doesn't exist yet, then run ct-ng
if [[ -z ${DIRTY+x} || ! -e "${PREFIX}/bin/x86_64-sarc-linux-gnueabi-gcc" ]]; then
   ct-ng build;
fi

chmod 755 $PREFIX

mkdir -p $PREFIX/etc/conda/activate.d
cp $RECIPE_DIR/activate.sh $PREFIX/etc/conda/activate.d/compiler_linux-64_linux-cos5-64-activate.sh

mkdir -p $PREFIX/etc/conda/deactivate.d
cp $RECIPE_DIR/deactivate.sh $PREFIX/etc/conda/deactivate.d/compiler_linux-64_linux-cos5-64-deactivate.sh
