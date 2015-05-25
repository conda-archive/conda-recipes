REM Configure step
copy jconfig.vc jconfig.h
if errorlevel 1 exit 1

REM Build step
nmake /f makefile.vc nodebug=1
if errorlevel 1 exit 1

REM Install step
copy libjpeg.lib %LIBRARY_LIB%\
if errorlevel 1 exit 1
copy libjpeg.lib %LIBRARY_LIB%\jpeg.lib
if errorlevel 1 exit 1
copy jpeglib.h %LIBRARY_INC%\
if errorlevel 1 exit 1
copy jconfig.h %LIBRARY_INC%\
if errorlevel 1 exit 1
copy jmorecfg.h %LIBRARY_INC%\
if errorlevel 1 exit 1
copy jerror.h %LIBRARY_INC%\
if errorlevel 1 exit 1
copy jpegint.h %LIBRARY_INC%\
if errorlevel 1 exit 1
