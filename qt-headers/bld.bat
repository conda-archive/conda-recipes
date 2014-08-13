mkdir "%PREFIX%\include\PyQt4"
if errorlevel 1 exit 1

mkdir "%PREFIX%\libs\PyQt4"
if errorlevel 1 exit 1

REM The installer always wants to install to C:\Qt\4.8.6; it ignores /D=
"%SRC_DIR%\qt-opensource-windows-x86-4.8.6.exe" /S
if errorlevel 1 exit 1

cd C:\Qt\4.8.6

xcopy /S /E include "%PREFIX%\include\PyQt4"
if errorlevel 1 exit 1

xcopy /S /E lib "%PREFIX%\libs\PyQt4"
if errorlevel 1 exit 1