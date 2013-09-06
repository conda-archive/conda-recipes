%PYTHON% setup.py install
if errorlevel 1 exit 1

if "%ARCH%"=="32" (
   set MINGW_NAME=i686-w64-mingw32
) else (
   set MINGW_NAME=x86_64-w64-mingw32
)

for %%x in (libgcc_s_sjlj-1.dll libgfortran-3.dll libquadmath-0.dll) do (
   copy %PREFIX%\MinGW\%MINGW_NAME%\lib\%%x %SP_DIR%\pymc\
   if errorlevel 1 exit 1
)
