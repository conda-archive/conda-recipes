cd build.vc14

if "%ARCH%"=="32" (
    set PLATFORM=Win32
) else (
    set PLATFORM=x64
)

msbuild lib_mpir_gc\lib_mpir_gc.vcxproj /p:Configuration=Release /p:Platform=%PLATFORM%
msbuild lib_mpir_cxx\lib_mpir_cxx.vcxproj /p:Configuration=Release /p:Platform=%PLATFORM%

mkdir %PREFIX%\mpir\lib\%PLATFORM%\Release

copy lib_mpir_gc\%PLATFORM%\Release\mpir.lib %PREFIX%\mpir\lib\%PLATFORM%\Release\mpir.lib
copy lib_mpir_cxx\%PLATFORM%\Release\mpirxx.lib %PREFIX%\mpir\lib\%PLATFORM%\Release\mpirxx.lib

copy lib_mpir_gc\%PLATFORM%\Release\mpir.lib %PREFIX%\mpir\lib\%PLATFORM%\Release\gmp.lib
copy lib_mpir_cxx\%PLATFORM%\Release\mpirxx.lib %PREFIX%\mpir\lib\%PLATFORM%\Release\gmpxx.lib

cd ..
xcopy lib %PREFIX%\mpir\lib\ /E