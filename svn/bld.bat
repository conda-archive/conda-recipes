if "%ARCH%"=="32" (
   set "PLATFORM=Win32"
) else (
  set "PLATFORM=x64"
)



:: These are here to map cl.exe version numbers, which we use to figure out which
::   compiler we are using, and which compiler consumers of svn need to use, to MSVC
::   year numbers.
:: Update this with any new MSVC compiler you might use.
echo @echo 15=2008 >> msvc_versions.bat
echo @echo 16=2010 >> msvc_versions.bat
echo @echo 19=2015 >> msvc_versions.bat

for /f "delims=" %%A in ('cl /? 2^>^&1 ^| findstr /C:"Version"') do set "CL_TEXT=%%A"
FOR /F "tokens=1,2 delims==" %%i IN ('msvc_versions.bat') DO echo %CL_TEXT% | findstr /C:"Version %%i" > nul && set VSTRING=%%j && goto FOUND
EXIT 1
:FOUND

python gen-make.py -t vcproj --vsnet-version=%VSTRING% ^
             --with-openssl=%LIBRARY_PREFIX% ^
             --with-zlib=%LIBRARY_PREFIX% ^
             --with-apr=%LIBRARY_PREFIX% ^
             --with-apr-util=%LIBRARY_PREFIX% ^
             --with-apr-iconv=%LIBRARY_PREFIX% ^
             --with-sqlite=%LIBRARY_PREFIX% ^
             --release

msbuild subversion_vcnet.sln /t:__ALL_TESTS__ /p:Configuration=Release /p:Platform=%PLATFORM%
