mkdir build

set "FORWARD_SLASHED_PREFIX=%PREFIX:\=/%"
set "FORWARD_SLASHED_LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%"
set "FORWARD_SLASHED_SRC_DIR=%SRC_DIR:\=/%"

for /f "delims=" %%A in ('%PREFIX%\python -c "import sys; print(sys.version_info.major)"') DO SET PY_MAJOR=%%A
for /f "delims=" %%A in ('%PREFIX%\python -c "import sys; print(sys.version_info.minor)"') DO SET PY_MINOR=%%A

git clone https://github.com/Itseez/opencv_contrib
cd opencv_contrib
git checkout tags/%PKG_VERSION%
TYPE %RECIPE_DIR%\windows_compiler.patch | MORE /P > contrib.patch
patch -p0 -i contrib.patch
cd ..


set PY_LIB=python%PY_MAJOR%%PY_MINOR%.lib

:: These are here to map cl.exe version numbers, which we use to figure out which
::   compiler we are using, and which compiler consumers of Qt need to use, to MSVC
::   year numbers, which is how qt identifies MSVC versions.
:: Update this with any new MSVC compiler you might use.
echo @echo 15=9 2008> msvc_versions.bat
echo @echo 16=10 2010>> msvc_versions.bat
echo @echo 19=14 2015>> msvc_versions.bat

for /f "delims=" %%A in ('cl /? 2^>^&1 ^| findstr /C:"Version"') do set "CL_TEXT=%%A"
FOR /F "tokens=1,2 delims==" %%i IN ('msvc_versions.bat') DO echo %CL_TEXT% | findstr /C:"Version %%i" > nul && set VSTRING=%%j && goto FOUND
EXIT 1
:FOUND

if "%ARCH%" == "64" (
   set "VSTRING=%VSTRING%Win64"
)

call :TRIM VSTRING %VSTRING%

cd build

cmake -G "Visual Studio %VSTRING%"^
 -DCMAKE_BUILD_TYPE=Release^
 -DBUILD_TESTS=false^
 -DBUILD_PERF_TESTS=false^
 -DWITH_FFMPEG=OFF^
 -DCMAKE_INSTALL_PREFIX=%FORWARD_SLASHED_LIBRARY_PREFIX%^
 -DEXECUTABLE_OUTPUT_PATH=%FORWARD_SLASHED_LIBRARY_PREFIX%/bin^
 -DLIBRARY_OUTPUT_PATH=%FORWARD_SLASHED_LIBRARY_PREFIX%/lib^
 -DPYTHON%PY_MAJOR%_EXECUTABLE=%FORWARD_SLASHED_PREFIX%/python^
 -DPYTHON_INCLUDE_DIR=%FORWARD_SLASHED_PREFIX%/include^
 -DPYTHON_PACKAGES_PATH=%FORWARD_SLASHED_PREFIX%/Lib/site-packages/^
 -DPYTHON_LIBRARY=%FORWARD_SLASHED_PREFIX%/libs/%PY_LIB%^
 -DPYTHON%PY_MAJOR%_NUMPY_INCLUDE_DIRS=%FORWARD_SLASHED_PREFIX%/Lib/site-packages/numpy/core/include^
 -DCMAKE_INSTALL_PREFIX=%FORWARD_SLASHED_LIBRARY_PREFIX%^
 -DOPENCV_EXTRA_MODULES_PATH=%FORWARD_SLASHED_SRC_DIR%/opencv_contrib/modules^
 ..

if errorlevel 1 exit 1

for /F "tokens=1" %%A in ("%VSTRING%") do set VC_VER=%%A

REM VC9 is missing stdint.h.  Download one and put it where OpenCV will find it.
if "%VC_VER%" == "9" (
   curl -O http://msinttypes.googlecode.com/svn/trunk/stdint.h
   copy stdint.h %SRC_DIR%\modules\calib3d\include\stdint.h
   copy stdint.h %SRC_DIR%\modules\videoio\include\stdint.h
   copy stdint.h %SRC_DIR%\modules\highgui\include\stdint.h
)

if errorlevel 1 exit 1

cmake --build . --target INSTALL --config Release

if errorlevel 1 exit 1

if "%ARCH%" == "64" (
     robocopy %LIBRARY_PREFIX%\x64\vc%VC_VER%\ %LIBRARY_PREFIX%\ *.* /E
   ) else (
     robocopy %LIBRARY_PREFIX%\x86\vc%VC_VER%\ %LIBRARY_PREFIX%\ *.* /E
)
if %ERRORLEVEL% GEQ 8 exit 1

RD /S /Q "%LIBRARY_PREFIX%\bin\Release"
RD /S /Q "%LIBRARY_PREFIX%\bin\Debug"
RD /S /Q "%LIBRARY_PREFIX%\x64"
RD /S /Q "%LIBRARY_PREFIX%\x86"
RD /S /Q "%SRC_DIR%\opencv_contrib"
exit 0

:TRIM
  SetLocal EnableDelayedExpansion
  set Params=%*
  for /f "tokens=1*" %%a in ("!Params!") do EndLocal & set %1=%%b
  exit /B
