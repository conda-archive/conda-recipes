python setup.py install
if errorlevel 1 exit 1

if "%PY3K%"=="1" (
    rd /s /q %SP_DIR%\numpy
)

del scripts\README.rst
if errorlevel 1 exit 1

copy scripts\* %SCRIPTS%\
if errorlevel 1 exit 1
