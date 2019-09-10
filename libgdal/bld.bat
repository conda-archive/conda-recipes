REM build

if "%ARCH%"=="64" (
    set WIN64="WIN64=YES"
) else (
    set WIN64=
)

nmake /f makefile.vc ^
    %WIN64% ^
    GDAL_HOME=%LIBRARY_PREFIX% ^
    BINDIR=%LIBRARY_BIN% ^
    LIBDIR=%LIBRARY_LIB% ^
    INCDIR=%LIBRARY_INC% ^
    DATADIR=%LIBRARY_PREFIX%\data
if errorlevel 1 exit 1

nmake /f makefile.vc devinstall ^
    %WIN64% ^
    GDAL_HOME=%LIBRARY_PREFIX% ^
    BINDIR=%LIBRARY_BIN% ^
    LIBDIR=%LIBRARY_LIB% ^
    INCDIR=%LIBRARY_INC% ^
    DATADIR=%LIBRARY_PREFIX%\data
if errorlevel 1 exit 1
