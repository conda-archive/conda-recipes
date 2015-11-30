REM pick build configuration
set BUILD_CONFIG=Release

REM pick generator based on python version
if %PY_VER%==2.6 (
    set GENERATOR_NAME=Visual Studio 9 2008
)
if %PY_VER%==2.7 (
    set GENERATOR_NAME=Visual Studio 9 2008
)
if %PY_VER%==3.3 (
    set GENERATOR_NAME=Visual Studio 10 2010
)
if %PY_VER%==3.4 (
    set GENERATOR_NAME=Visual Studio 10 2010
)
if %PY_VER%==3.5 (
    set GENERATOR_NAME=Visual Studio 14 2015
)

REM pick architecture
set ARCH_NAME=x86
if %ARCH%==64 (
	set GENERATOR_NAME=%GENERATOR_NAME% Win64
	set ARCH_NAME=x86_64
)

REM tell cmake where Python is
set PYTHON_LIBRARY=%PREFIX%\libs\python%PY_VER:~0,1%%PY_VER:~2,1%.lib
set PYTHON_INCLUDE_DIR=%PREFIX%\include

REM generate visual studio solution
cmake -Wno-dev -G"%GENERATOR_NAME%" -DCMAKE_BUILD_TYPE=%BUILD_CONFIG% -DGDCM_BUILD_APPLICATIONS:BOOL=ON -DGDCM_BUILD_SHARED_LIBS:BOOL=ON -DGDCM_WRAP_PYTHON:BOOL=ON -DGDCM_USE_PVRG:BOOL=ON -DPYTHON_LIBRARY="%PYTHON_LIBRARY%" -DPYTHON_INCLUDE_DIR="%PYTHON_INCLUDE_DIR%" .
if errorlevel 1 exit 1

REM build
cmake --build .  --config %BUILD_CONFIG%
if errorlevel 1 exit 1

REM copy build output into package
set GDCMDIR=%SP_DIR%\gdcm

mkdir "%GDCMDIR%"
if errorlevel 1 exit 1

xcopy .\bin\%BUILD_CONFIG%\* "%GDCMDIR%"
if errorlevel 1 exit 1

REM link executables from Scripts dir so that they will be on the PATH
for %%f in ("%GDCMDIR%\*.exe") do echo %%f %%* >> "%SCRIPTS%\%%~nf.bat"
if errorlevel 1 exit 1

REM link python wrappers so that they will be importable
echo %GDCMDIR% >> "%SP_DIR%\gdcm.pth"
if errorlevel 1 exit 1

exit /b 0
