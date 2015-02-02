#!/bin/bash
./configure --with-python --prefix=$PREFIX \
--with-geos=$PREFIX/bin/geos-config \
--with-static-proj4=$PREFIX \
--with-hdf5=$PREFIX \
--with-hdf4=$PREFIX \
--with-netcdf=$PREFIX \
--with-xerces=$PREFIX \
--with-sqlite=$PREFIX \
--without-pam \
--with-python \
--disable-rpath

make 
make install

# Copy data files 
mkdir -p $PREFIX/share/gdal/
cp data/*csv $PREFIX/share/gdal/
cp data/*wkt $PREFIX/share/gdal/


