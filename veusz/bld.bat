REM setenv /Release /x86 /xp
REM set DISTUTILS_USE_SDK=1

"%PYTHON%" setup.py build
"%PYTHON%" setup.py install
if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
