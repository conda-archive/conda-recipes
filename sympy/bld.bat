python setup.py install
if errorlevel 1 exit 1

if "%PY3K%"=="0" (
    del %SP_DIR%\sympy\mpmath\tests\torture.py
    del %SP_DIR%\sympy\mpmath\tests\extratest_gamma.py
    del %SP_DIR%\sympy\mpmath\libmp\exec_py3.py
)
