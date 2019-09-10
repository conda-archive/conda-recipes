#!/bin/bash

# http://www.michael-joost.de/gdal_install.html
unset CC CPP CXX
export MAKEFLAGS=' -j8'

if [ `uname` == Darwin ]; then
    export LDFLAGS="$LDFLAGS -headerpad_max_install_names -liconv"
fi

export PYTHON=
bash configure \
    --without-python \
    --with-hdf5=$PREFIX \
    --with-netcdf=$PREFIX \
    --prefix=$PREFIX \
    --disable-static
make
make install

# strip symbols from library
strip --strip-unneeded $PREFIX/lib/libgdal.so.1.18.2

#ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
#DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
#mkdir -p $ACTIVATE_DIR
#mkdir -p $DEACTIVATE_DIR

#cp $RECIPE_DIR/posix/activate.sh $ACTIVATE_DIR/gdal-activate.sh
#cp $RECIPE_DIR/posix/deactivate.sh $DEACTIVATE_DIR/gdal-deactivate.sh
