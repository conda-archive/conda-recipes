:: Set the right msvc version according to Python version
if "%PY_VER%"=="2.7" (
    set MSVC_VER=9.0
    set LIB_VER=90
) else if "%PY_VER%"=="3.4" (
    set MSVC_VER=10.0
    set LIB_VER=100
) else (
    set MSVC_VER=14.0
    set LIB_VER=140
)

:: Start with bootstrap
call bootstrap.bat
if errorlevel 1 exit 1

:: Build step
.\b2 install ^
    --build-dir=buildboost ^
    --prefix=%LIBRARY_PREFIX% ^
    toolset=msvc-%MSVC_VER% ^
    address-model=%ARCH% ^
    variant=release ^
    threading=multi ^
    link=static,shared ^
    -j%CPU_COUNT% ^
    -s ZLIB_INCLUDE="%LIBRARY_INC%" ^
    -s ZLIB_LIBPATH="%LIBRARY_LIB%"
if errorlevel 1 exit 1

for /F "tokens=1,2,3 delims=." %%a in ("%PKG_VERSION%") do (
   set PKG_VERSION_MAJOR=%%a
   set PKG_VERSION_MINOR=%%b
   set PKG_VERSION_PATCH=%%c
)

:: Install fix-up for a non version-specific boost include
move %LIBRARY_INC%\boost-%PKG_VERSION_MAJOR%_%PKG_VERSION_MINOR%\boost %LIBRARY_INC%
if errorlevel 1 exit 1

:: Move dll's to LIBRARY_BIN
move %LIBRARY_LIB%\*vc%LIB_VER%-mt-%PKG_VERSION_MAJOR%_%PKG_VERSION_MINOR%.dll "%LIBRARY_BIN%"
if errorlevel 1 exit 1
