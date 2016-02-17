# https://gist.github.com/ethanwhite/71e24e387b10732510e5
from osgeo import gdal

gdal.AllRegister()
driver = gdal.GetDriverByName("netCDF")
gdal.Open("test.nc")
