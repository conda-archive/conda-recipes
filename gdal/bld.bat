for %%x in (gdal.py gdalconst.py gdalnumeric.py ogr.py osr.py osgeo) do (
    move %SRC_DIR%\%%x %SP_DIR%
    if errorlevel 1 exit 1
)

move %SRC_DIR%\GDAL-%PKG_VERSION%.dist-info %SP_DIR%
if errorlevel 1 exit 1
