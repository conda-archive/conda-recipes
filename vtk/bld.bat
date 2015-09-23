@echo off

mkdir build
cd build

if %PY3K%==1 (
    if "%PY_VER%"=="3.5" (
        set CMAKE_GENERATOR=Visual Studio 14 2015
    ) else (
        set CMAKE_GENERATOR=Visual Studio 10 2010
    )
) else (
    set CMAKE_GENERATOR=Visual Studio 9 2008
)


if %ARCH%==64 (
    set CMAKE_GENERATOR=%CMAKE_GENERATOR% Win64
)

cmake .. -G "%CMAKE_GENERATOR%" ^
    -Wno-dev ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_RPATH:STRING=%LIBRARY_LIB% ^
    -DCMAKE_INSTALL_NAME_DIR=%LIBRARY_LIB% ^
    -DBUILD_DOCUMENTATION=OFF ^
    -DVTK_HAS_FEENABLEEXCEPT=OFF ^
    -DBUILD_TESTING=OFF ^
    -DBUILD_EXAMPLES=OFF ^
    -DBUILD_SHARED_LIBS=ON ^
    -DVTK_WRAP_PYTHON=ON ^
    -DPYTHON_EXECUTABLE=%PYTHON% ^
    -DPYTHON_INCLUDE_PATH=%PREFIX%\\include ^
    -DPYTHON_LIBRARY=%PREFIX%\\libs\\python27.lib ^
    -DVTK_INSTALL_PYTHON_MODULE_DIR=%PREFIX%\\Lib\\site-packages ^
    -DVTK_USE_OFFSCREEN=ON ^
    -DModule_vtkRenderingMatplotlib=ON

cmake --build . --config Release --target ALL_BUILD 1>output.txt 2>&1
if errorlevel 1 exit 1

cmake --build . --config Release --target INSTALL
if errorlevel 1 exit 1
