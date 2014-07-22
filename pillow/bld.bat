set TIFF_ROOT=%LIBRARY_PREFIX%
set JPEG_ROOT=%LIBRARY_PREFIX%
set ZLIB_ROOT=%LIBRARY_PREFIX%
set FREETYPE2_ROOT=%LIBRARY_PREFIX%
set LIB=%LIBRARY_LIB%
set INCLUDE=%LIBRARY_INC%
python setup.py install
if errorlevel 1 exit 1

rd /s /q %SP_DIR%\__pycache__
if errorlevel 1 exit 1
