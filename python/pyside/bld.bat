rd /s /q %SP_DIR%
move %SRC_DIR%\Lib\site-packages %STDLIB_DIR%

if "%PY3K%"=="1" (
    %SYS_PREFIX%\Scripts\prepend-dlls %SP_DIR%\PySide\__init__.py
    if errorlevel 1 exit 1
)
