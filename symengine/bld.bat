mkdir build
cd build

if "%ARCH%"=="32" (
    set PLATFORM=Win32
	set GENERATOR="Visual Studio 14 2015"
) else (
    set PLATFORM=x64
	set GENERATOR="Visual Studio 14 2015 Win64"
)

cmake -G %GENERATOR% ^
    -D GMP_DIR=%PREFIX%\mpir\lib\%PLATFORM%\Release ^
    -D CMAKE_INSTALL_PREFIX=%PREFIX% ^
    -D BUILD_TESTS=no ^
    -D BUILD_BENCHMARKS=no ^
	-D CMAKE_CXX_FLAGS_RELEASE="/MT /W1 /O2 /Ob2 /D NDEBUG" ^
    ..

cmake --build . --config Release --target install
