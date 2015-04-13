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
