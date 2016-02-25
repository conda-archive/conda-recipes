FOR %%F IN (%SRC_DIR%\*.exe) DO (
    set FILENAME=%%F
    goto found_file
)
:found_file

%FILENAME% /VERYSILENT /DIR="%TEMP%\rtools"
if errorlevel 1 exit 1

REM Option 1:
REM Copy absolutely everything as it was given:
REM bin => Cygwin shell
REM gcc-4.6.3 => MinGW-w64 multiarch compilers
REM robocopy %TEMP%\rtools %LIBRARY_PREFIX% /E *

REM Option 2:
REM Copy the toolchain and the embedded Cygwin
REM shell into the same prefix:
REM gcc-4.6.3 => MinGW-w64 multiarch compilers
robocopy %TEMP%\rtools\bin %LIBRARY_PREFIX%\bin /E *
robocopy %TEMP%\rtools\gcc-4.6.3 %LIBRARY_PREFIX% /E *

copy %TEMP%\rtools\COPYING %SRC_DIR%

RD /S /Q "%TEMP%\rtools"
exit 0
