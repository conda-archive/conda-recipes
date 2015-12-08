mkdir build
cd build

cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% %SRC_DIR%
if errorlevel 1 exit 1

REM Build C libraries and tools
nmake
if errorlevel 1 exit 1

REM Install step
nmake install
if errorlevel 1 exit 1
