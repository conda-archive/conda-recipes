echo $(pwd)
mkdir -p .build/tarballs
if [[ ! -e ".build/tarballs/linux-3.13.11.tar.xz" ]]; then
    curl -L https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.13.11.tar.xz -o $(pwd)/.build/tarballs/linux-3.13.11.tar.xz;
fi

cp $RECIPE_DIR/.config .config

# If dirty is unset or the binary doesn't exist yet, then run ct-ng
if [[ -z ${DIRTY+x} || ! -e "${PREFIX}/bin/aarch64-sarc-linux-gnueabi-gcc" ]]; then
   ct-ng build;
fi

chmod 755 $PREFIX

mkdir -p $PREFIX/etc/conda/activate.d
cp $RECIPE_DIR/compiler_linux-64_linux-aarch64-activate.sh $PREFIX/etc/conda/activate.d

mkdir -p $PREFIX/etc/conda/deactivate.d
cp $RECIPE_DIR/compiler_linux-64_linux-aarch64-deactivate.sh $PREFIX/etc/conda/deactivate.d
