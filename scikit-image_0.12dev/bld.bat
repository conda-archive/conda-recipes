python setup.py install
if errorlevel 1 exit 1

REM del %SCRIPTS%\cython.pyc

if "%PY3K%"=="1" (
    rd /s /q %SP_DIR%\numpy
)

REM rd /s /q %SCRIPTS%