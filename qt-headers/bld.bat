mkdir "%PREFIX%\include\PyQt4\include"
if errorlevel 1 exit 1

mkdir "%PREFIX%\include\PyQt4\src"
if errorlevel 1 exit 1

mkdir "%PREFIX%\libs\PyQt4"
if errorlevel 1 exit 1

REM The installer always wants to install to C:\Qt\4.8.6; it ignores /D=
REM "%SRC_DIR%\qt-opensource-windows-x86-4.8.6.exe" /S
REM The installer modifies the headers, causing builds to fail.
REM Use included 7-zip to extract the installer files instead.
copy "%SRC_DIR%\qt-opensource-windows-x86-4.8.6.exe" "%RECIPE_DIR%"
if errorlevel 1 exit 1

REM 7z from http://sourceforge.net/projects/portableapps/files/7-Zip%20Portable/7-ZipPortable_9.20_Rev_3.paf.exe/download
cd %RECIPE_DIR%
7z x qt-opensource-windows-x86-4.8.6.exe $OUTDIR\bin\lib $OUTDIR\bin\src $OUTDIR\bin\include
if errorlevel 1 exit 1

cd $OUTDIR\bin
if errorlevel 1 exit 1

xcopy /S /E include "%PREFIX%\include\PyQt4\include"
if errorlevel 1 exit 1

xcopy /S /E src "%PREFIX%\include\PyQt4\src"
if errorlevel 1 exit 1

xcopy /S /E lib "%PREFIX%\libs\PyQt4"
if errorlevel 1 exit 1
