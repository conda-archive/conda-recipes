setlocal EnableDelayedExpansion
:: Jom is much faster, but if you need to debug something, making Visual Studio
:: projects can be useful. Packages are always built with Jom though. That side
:: of the process has never been tested using Visual Studio but it might work.
set USE_JOM=1
:: set BUILD_TYPE=RelWithDebInfo
set BUILD_TYPE=Release

FOR /f "usebackqeol=; tokens=1 delims=." %%A IN ('%PKG_VERSION%') DO set RSTUDIO_VERSION_MAJOR=%%A
FOR /f "usebackqeol=; tokens=2 delims=." %%A IN ('%PKG_VERSION%') DO set RSTUDIO_VERSION_MINOR=%%A
FOR /f "usebackqeol=; tokens=3 delims=." %%A IN ('%PKG_VERSION%') DO set RSTUDIO_VERSION_PATCH=%%A

cd dependencies\windows
call install-dependencies.cmd
cd ..\..

cd dependencies\common
mkdir rmarkdown
cd rmarkdown
call conda install -c r --no-deps --yes --copy --prefix "%CD%" r-markdown
cd ..\..\..

mkdir build
cd build

if "%ARCH%"=="32" (
   set R_ARCH=i386
   set MS_MACH=X86
) else (
   set R_ARCH=x64
   set MS_MACH=X64
)

:: Create an import library for the mingw-w64 compiled R.dll. We must not use
:: MS's dumpbin for this as that doesn't add 'DATA' annotations to variables.
:: mingw-w64's gendef must be used instead.
:: dumpbin /exports %PREFIX%\R\bin\!R_ARCH!\R.dll > %PREFIX%\R\bin\!R_ARCH!\R.dll.exports.txt
:: echo LIBRARY R > %PREFIX%\R\bin\!R_ARCH!\R.def
:: echo EXPORTS >> %PREFIX%\R\bin\!R_ARCH!\R.def
:: for /f "skip=19 tokens=4" %%A in (%PREFIX%\R\bin\!R_ARCH!\R.dll.exports.txt) do echo %%A >> %PREFIX%\R\bin\!R_ARCH!\R.def
gendef %PREFIX%\R\bin\!R_ARCH!\R.dll - > %PREFIX%\R\bin\!R_ARCH!\R.def
lib /def:%PREFIX%\R\bin\!R_ARCH!\R.def /out:%PREFIX%\R\bin\!R_ARCH!\R.lib /machine:!MS_MACH!

:: .. and one for Rgraphapp.dll. Unfortunately, the first export from this is bad:
:: ".refptr.GAI_active_windows.refptr.GAI_app_control_proc..." so this horrible loop
:: is used to create a new header then copy everything after line 8 from the defs file.
:: Yes, I know this is awful.
gendef %PREFIX%\R\bin\!R_ARCH!\Rgraphapp.dll - > %PREFIX%\R\bin\!R_ARCH!\Rgraphapp.dll.exports.txt
echo LIBRARY Rgraphapp > %PREFIX%\R\bin\!R_ARCH!\Rgraphapp.def
echo EXPORTS >> %PREFIX%\R\bin\!R_ARCH!\Rgraphapp.def
for /f "delims= skip=8" %%A in (%PREFIX%\R\bin\!R_ARCH!\Rgraphapp.dll.exports.txt) do echo %%A >> %PREFIX%\R\bin\!R_ARCH!\Rgraphapp.def
lib /def:%PREFIX%\R\bin\!R_ARCH!\Rgraphapp.def /out:%PREFIX%\R\bin\!R_ARCH!\Rgraphapp.lib /machine:!MS_MACH!

set BOOST_ROOT=%PREFIX%

:: It's not possible to use CMAKE_BUILD_TYPE=Debug here because
:: conda's Boost and Qt packages do not provide debug libraries:
:: '_ITERATOR_DEBUG_LEVEL': value '0' doesn't match value '2'
:: 'RuntimeLibrary': value 'MD_DynamicRelease' doesn't match value 'MDd_DynamicDebug'

if "%USE_JOM%" == "1" (
::  for /f "delims=" %%A in ('where cl.exe') do set "CL_EXE=%%A"
::  set "CL_EXE=!CL_EXE:\=/!"
  echo Using cmake -G"NMake Makefiles"
  cmake -G"NMake Makefiles" ^
        -DCMAKE_INSTALL_PREFIX=%PREFIX%\Library ^
        -DRSTUDIO_TARGET=Desktop ^
        -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
        -DLIBR_HOME=%PREFIX%\R ^
        -DLIBR_CORE_LIBRARY=%PREFIX%\R\bin\!R_ARCH!\R.lib ^
        -DLIBR_GRAPHAPP_LIBRARY=%PREFIX%\R\bin\!R_ARCH!\Rgraphapp.lib ^
        -DQT_QMAKE_EXECUTABLE=%PREFIX%\Library\bin\qmake.exe ^
        -DCMAKE_MAKE_PROGRAM=jom ^
        ..
::  if "%PROCESSOR_ARCHITECTURE%"=="x86" (
::     echo Early test for OpenJDK heap allocation problem
::     pushd %CONDA_PREFIX%\conda-bld\work\src\gwt
::     ant
::     popd
::  )
  jom VERBOSE=1
  jom install VERBOSE=1
) else (
:: /MP == object level parallelism, but when added on its own
:: WIN32, _WINDOWS and /EHsc are dropped, so add them back too.
:: This needs to be fixed in the CMakeLists.txt files.
  echo Using cmake -G"%CMAKE_GENERATOR%"
  cmake -G"%CMAKE_GENERATOR%" ^
        -DCMAKE_INSTALL_PREFIX=%PREFIX%\Library ^
        -DRSTUDIO_TARGET=Desktop ^
        -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
        -DLIBR_HOME=%PREFIX%\R ^
        -DLIBR_CORE_LIBRARY=%PREFIX%\R\bin\!R_ARCH!\R.lib ^
        -DLIBR_GRAPHAPP_LIBRARY=%PREFIX%\R\bin\!R_ARCH!\Rgraphapp.lib ^
        -DQT_QMAKE_EXECUTABLE=%PREFIX%\Library\bin\qmake.exe ^
        -DCMAKE_CXX_FLAGS="/MP /DWIN32 /D_WINDOWS /EHsc" ^
        -DCMAKE_C_FLAGS="/MP /DWIN32 /D_WINDOWS /EHsc" ^
        ..
  cmake --build . --config %BUILD_TYPE% --target INSTALL
)

IF NOT EXIST %PREFIX%\Menu mkdir %PREFIX%\Menu
copy %RECIPE_DIR%\menu-windows.json %PREFIX%\Menu\
copy %RECIPE_DIR%\rstudio.ico %PREFIX%\Menu\

del %PREFIX%\R\bin\!R_ARCH!\Rgraphapp.dll.exports.txt
del %PREFIX%\R\bin\!R_ARCH!\Rgraphapp.lib
del %PREFIX%\R\bin\!R_ARCH!\R.def
del %PREFIX%\R\bin\!R_ARCH!\R.lib
