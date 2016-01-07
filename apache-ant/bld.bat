setlocal enableextensions enabledelayedexpansion

set JAVA_HOME=%PREFIX%\Library
set JRE_HOME=%JAVA_HOME%\jre

REM Write the batch file to /Scripts/ant
echo f | xcopy /f /y %RECIPE_DIR%\ant-script.py %PREFIX%\Scripts\ant-script.py
echo f | xcopy /f /y %RECIPE_DIR%\ant.bat %PREFIX%\Scripts\ant.bat
if errorlevel 1 exit 1

REM Make a share folder and copy the contents into it
mkdir %PREFIX%\share
xcopy /i /e "%SRC_DIR%\*.*" "%PREFIX%\share\apache-ant"
if errorlevel 1 exit /b 1