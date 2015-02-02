import osgeo._gdal
import osgeo._gdalconst
import osgeo._ogr
import osgeo._osr
import osgeo
import gdal
import gdalconst
import ogr
import osr
import urllib2

print( "OGR Vector drivers")
print("==================")
cnt = ogr.GetDriverCount()
for i in range(cnt):
    print(ogr.GetDriver(i).GetName())

print ("GDAL Raster drivers")
print ("===================")
cnt = gdal.GetDriverCount()
for i in xrange(cnt):
    print (gdal.GetDriver(i).LongName)

print ("Total number of vector drivers: %d" % ogr.GetDriverCount())
print ("Total number of vector drivers: %d" % gdal.GetDriverCount())

print ("Testing opening a MODIS file...")
fp = open ( "MCD45A1.A2006213.h17v04.051.2013060204001.hdf", 'w')
fp.write ( urllib2.urlopen("http://e4ftl01.cr.usgs.gov/MOTA/MCD45A1.051/2006.08.01/MCD45A1.A2006213.h17v04.051.2013060204001.hdf").read() )
fp.close()
g = gdal.Open ( "MCD45A1.A2006213.h17v04.051.2013060204001.hdf" )
print ( g.GetSubDatasets() )

import os1_hw
