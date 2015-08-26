#!/bin/sh

VF=$RECIPE_DIR/vimfiles
if [ ! -d $VF ]; then
    echo Hint: git clone https://github.com/tpn/vimfiles in recipe dir.
fi

./configure --prefix=$PREFIX    \
            --without-x         \
            --without-gnome     \
            --without-tclsh     \
            --without-local-dir \
            --enable-gui=no     \
            --enable-cscope     \
            --enable-pythoninterp=yes

make
make install

VIM=$PREFIX/vim
VIM74=$VIM/vim74

mkdir -p $VIM
mkdir -p $VIM74

if [ -d $VF ]; then
    cp -r $VF/doc $VIM74
    cp -r $VF/colors $VIM74
    cp -r $VF/plugin $VIM74
    cp -r $VF/nerdtree_plugin $VIM74
fi

# vim:set ts=8 sw=4 sts=4 tw=78 et:
