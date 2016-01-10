set INCLUDE=%INCLUDE%;%LIBRARY_INC%
set LIB=%LIB%;%LIBRARY_LIB%
set LIBPATH=%LIBPATH%;%LIBRARY_LIB%

REM Build step
nmake /f Makefile.vc
if errorlevel 1 exit 1

REM Install step
copy libtiff\libtiff.dll %LIBRARY_BIN%\
if errorlevel 1 exit 1
copy libtiff\libtiff.lib %LIBRARY_LIB%\
if errorlevel 1 exit 1
copy libtiff\libtiff.lib %LIBRARY_LIB%\tiff.lib
if errorlevel 1 exit 1
copy libtiff\libtiff_i.lib %LIBRARY_LIB%\
if errorlevel 1 exit 1
xcopy libtiff\*.h %LIBRARY_INC%\
if errorlevel 1 exit 1
