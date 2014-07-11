mkdir build
cd build

REM Override cmake generator to visual studio 2010
if "%ARCH%" == "32" set CMAKE_GENERATOR=Visual Studio 10
if "%ARCH%" == "64" set CMAKE_GENERATOR=Visual Studio 10 Win64
if "%ARCH%" == "32" set MSVC_VCVARS_PLATFORM=x86
if "%ARCH%" == "64" set MSVC_VCVARS_PLATFORM=amd64

set MSVC_VERSION=10.0

REM Configure the appropriate visual studio command line environment
if "%PROGRAMFILES(X86)%" == "" set VCDIR=%PROGRAMFILES%\Microsoft Visual Studio %MSVC_VERSION%\VC
if NOT "%PROGRAMFILES(X86)%" == "" set VCDIR=%PROGRAMFILES(X86)%\Microsoft Visual Studio %MSVC_VERSION%\VC
call "%VCDIR%\vcvarsall.bat" %MSVC_VCVARS_PLATFORM%
IF %ERRORLEVEL% NEQ 0 exit /b 1

REM Configure step
cmake -G "%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE=Release -DDYND_INSTALL_LIB=ON -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% %SRC_DIR%
if errorlevel 1 exit /b 1

REM Build step
devenv %PKG_NAME%.sln /Build "%RELEASE_TARGET%"
if errorlevel 1 exit /b 1

REM Install step
devenv %PKG_NAME%.sln /Build "%RELEASE_TARGET%" /Project INSTALL
if errorlevel 1 exit /b 1
