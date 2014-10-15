mkdir build
cd build

REM Configure step
set CMAKE_CUSTOM=
cmake -G "%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% %CMAKE_CUSTOM% %SRC_DIR%
if errorlevel 1 exit 1

REM Build step
devenv %PKG_NAME%.sln /Build "%RELEASE_TARGET%"
if errorlevel 1 exit 1

REM Install step
devenv %PKG_NAME%.sln /Build "%RELEASE_TARGET%" /Project INSTALL
if errorlevel 1 exit 1

REM Make copies of the .lib files without the embedded version number
copy %LIBRARY_LIB%\libpng15.lib %LIBRARY_LIB%\libpng.lib
if errorlevel 1 exit 1
copy %LIBRARY_LIB%\libpng15_static.lib %LIBRARY_LIB%\libpng_static.lib
if errorlevel 1 exit 1
