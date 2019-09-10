%PYTHON% setup.py build_ext --include-dirs %LIBRARY_INC% --library-dirs %LIBRARY_LIB% --gdal-config %LIBRARY_BIN%\gdal-config
if errorlevel 1 exit 1

%PYTHON% setup.py build_py
if errorlevel 1 exit 1

%PYTHON% setup.py build_scripts
if errorlevel 1 exit 1

%PYTHON% setup.py install --single-version-externally-managed --root=C:\
if errorlevel 1 exit 1

REM copy gdal111.dll to python directory
copy %LIBRARY_BIN%\gdal111.dll %SP_DIR%\osgeo
if errorlevel 1 exit 1
