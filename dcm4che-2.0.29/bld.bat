setlocal enableextensions enabledelayedexpansion

REM set PREFIX=C:\Users\Ivo\Anaconda3\envs\_build
REM set SRC_DIR=.
REM set SCRIPTS=C:\Users\Ivo\Anaconda3\envs\_build\Scripts

REM We don't have to compile from source, we just copy everything over to the %PREFIX% dir instead
REM Run Maven install on the dcm4che source
REM call mvn install assembly:assembly
REM if errorlevel 1 exit /b 1

REM Create a folder in the build environment
mkdir %PREFIX%\dcm4che
if errorlevel 1 exit /b 1

echo Copying over the binaries
xcopy /i /e "%SRC_DIR%\*.*" "%PREFIX%\dcm4che"
if errorlevel 1 exit /b 1

echo Creating batch files that simply link to the batch files in dmc4che/bin
for %%f in ("%PREFIX%\dcm4che\bin\*.bat") do echo %%f %%* >> "%SCRIPTS%\%%~nf.bat"
if errorlevel 1 exit /b 1