REM Building on Win32 may throw: missing MSVCR71.dll
REM INFO: https://msdn.microsoft.com/en-us/library/abx4dbyh(vs.71).aspx

python setup.py install
if errorlevel 1 exit 1
