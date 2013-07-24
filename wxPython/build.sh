mkdir bld
cd bld
../configure --prefix=$PREFIX \
    --with-gtk \
    --with-opengl \
    --enable-geometry \
    --enable-graphics_ctx \
    --enable-sound --with-sdl \
    --enable-mediactrl \
    --enable-display \
    --enable-monolithic \

make
make -C contrib/src/gizmos
make -C contrib/src/stc

make install
make -C contrib/src/gizmos install
make -C contrib/src/stc install

export WX_CONFIG=$PREFIX/bin/wx-config

cd ../wxPython
python setup.py build_ext --inplace
