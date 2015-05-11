#!/bin/bash

# http://www.michael-joost.de/gdal_install.html
unset CC CPP CXX

bash configure \
    --with-python=$PREFIX/bin/python \
    --with-hdf5=$PREFIX \
    --with-netcdf=$PREFIX \
    --prefix=$PREFIX
make
make install

ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/posix/activate.sh $ACTIVATE_DIR/gdal-activate.sh
cp $RECIPE_DIR/posix/deactivate.sh $DEACTIVATE_DIR/gdal-deactivate.sh
