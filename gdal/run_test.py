import osgeo._gdal
import osgeo._gdalconst
import osgeo._ogr
import osgeo._osr
import osgeo
import gdal
import gdalconst
import ogr
import osr

cnt = ogr.GetDriverCount()
for i in range(cnt):
    print(ogr.GetDriver(i).GetName())

driver = gdal.GetDriverByName("netCDF")
assert driver is not None

import os1_hw
