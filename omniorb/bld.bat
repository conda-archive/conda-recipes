
cd src
if errorlevel 1 exit 1

make export
if errorlevel 1 exit 1

cd ../
if errorlevel 1 exit 1

MKDIR %LIBRARY_LIB%
XCOPY /E lib\x86_win32\* %LIBRARY_LIB%\
if errorlevel 1 exit 1

MKDIR %SP_DIR%
XCOPY /E lib\python\* %SP_DIR%\
if errorlevel 1 exit 1

MKDIR %LIBRARY_BIN%
XCOPY /E bin\x86_win32\* %LIBRARY_BIN%\
if errorlevel 1 exit 1
