set SLN_FILE=builds\win32\vc2008\freetype.sln
set SLN_CFG=LIB Release
if "%ARCH%"=="32" (set SLN_PLAT=Win32) else (set SLN_PLAT=x64)

REM The shipped .sln file is accompanied by documentation saying to do this.
C:\cygwin\bin\unix2dos %SLN_FILE%

REM Build step
devenv "%SLN_FILE%" /Build "%SLN_CFG%|%SLN_PLAT%"
if errorlevel 1 exit 1

REM Install step
mkdir %LIBRARY_INC%\freetype
copy objs\win32\vc2008\freetype2410.lib %LIBRARY_LIB%\
if errorlevel 1 exit 1
copy objs\win32\vc2008\freetype2410.lib %LIBRARY_LIB%\freetype.lib
if errorlevel 1 exit 1
copy include\ft2build.h %LIBRARY_INC%\
if errorlevel 1 exit 1
xcopy /S include\freetype\*.* %LIBRARY_INC%\freetype\
if errorlevel 1 exit 1
