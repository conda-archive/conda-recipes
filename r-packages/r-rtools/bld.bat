FOR %%F IN (%SRC_DIR%\*.exe) DO (
    set FILENAME=%%F
    goto found_file
)
:found_file

%FILENAME% /SILENT /DIR="%TEMP%\rtools"
if errorlevel 1 exit 1

robocopy %TEMP%\rtools\bin %LIBRARY_BIN% /E *
robocopy %TEMP%\rtools\mingw_%ARCH% %LIBRARY_PREFIX% /E *
robocopy %TEMP%\rtools\mingw_libs\include\ %LIBRARY_PREFIX%\include /E *

if "%ARCH%" == "64" (
    robocopy %TEMP%\rtools\mingw_libs\lib\x64 %LIBRARY_PREFIX%\lib /E *
) else (
    robocopy %TEMP%\rtools\mingw_libs\lib\i386 %LIBRARY_PREFIX%\lib /E *
)

RD /S /Q "%TEMP%\rtools"
exit 0
