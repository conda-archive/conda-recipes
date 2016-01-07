setlocal enableextensions enabledelayedexpansion

REM set PREFIX=C:\Users\Ivo\Anaconda3\envs\_build
REM set SRC_DIR=.
REM set SCRIPTS=C:\Users\Ivo\Anaconda3\envs\_build\Scripts


REM Run Maven install on the dcm4che source
call mvn install assembly:assembly
REM if errorlevel 1 exit /b 1

REM Create a folder in the build environment
mkdir %PREFIX%\dcm4che
if errorlevel 1 exit /b 1

echo Copying the source
REM Find all jar files and copy them over to this folder
for /r %%f in (*.jar) do (
    echo f | xcopy /f /y %%f %PREFIX%\dcm4che\%%~nxf
)
if errorlevel 1 exit /b 1

echo Creating batch files
REM Make batch files that map to the jar files
for %%f in ("%PREFIX%\dcm4che\*.jar") do (
    echo java -jar %%f %%* >> "%SCRIPTS%\%%~nf.bat"

if errorlevel 1 exit /b 1