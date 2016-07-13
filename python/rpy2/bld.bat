@rem Mixing MS CRT headers and mingw-w64 headers doesn't work
@rem so build the whole thing with mingw-w64 instead.
echo [build]              > setup.cfg
echo compiler = mingw32  >> setup.cfg
"%PYTHON%" setup.py install
if errorlevel 1 exit 1

:: Add more build steps here, if they are necessary.

:: See
:: http://docs.continuum.io/conda/build.html
:: for a list of environment variables that are set during the build process.
