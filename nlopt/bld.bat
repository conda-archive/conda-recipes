@rem See https://github.com/jyypma/nloptr/blob/master/INSTALL.windows
cp "%RECIPE_DIR%\CMakeLists.txt" .
if errorlevel 1 exit 1
cp "%RECIPE_DIR%\config.cmake.h.in" .
if errorlevel 1 exit 1

cmake -DCMAKE_INSTALL_PREFIX="%PREFIX%".
if errorlevel 1 exit 1

if "%ARCH%"=="32" (
    set RELEASE_TARGET="Release^|Win32"
) else (
    set RELEASE_TARGET="Release^|x64"
)

REM Build step
devenv NLOPT.sln /Build "%RELEASE_TARGET%"
if errorlevel 1 exit /b 1

REM Install step
devenv NLOPT.sln /Build "%RELEASE_TARGET%" /Project INSTALL
if errorlevel 1 exit /b 1
