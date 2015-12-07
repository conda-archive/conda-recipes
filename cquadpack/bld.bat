if "%CMAKE_GENERATOR%" == "" (
    set CMAKE_GENERATOR=NMake Makefiles
)
mkdir build
cd build

REM Configure step
cmake -G "%CMAKE_GENERATOR%" -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% -DCMAKE_DEBUG_POSTFIX=d -DBUILD_SHARED_LIBS=True %SRC_DIR%
if errorlevel 1 exit 1

REM Build step
cmake --build . --config Release --target INSTALL
cmake --build . --config Debug --target INSTALL
if errorlevel 1 exit 1
