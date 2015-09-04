:: conda-build tries to compile .pyc files in Python 2 environment, but Invoke
:: has yaml for Python3 codebase, which fails on Python2.
:: Related question on conda-build issue tracker:
:: https://github.com/conda/conda-build/pull/317#commitcomment-12926020
:: WARNING: this has to be removed when noarch_python is enabled!
if "%PY_VER%" == "2.7" rmdir /S /Q "invoke\vendor\yaml3"

"%PYTHON%" setup.py install
if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.