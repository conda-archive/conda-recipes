@rem Download the nlopt source
python "%RECIPE_DIR%\download_nlopt.py"
if errorlevel 1 exit 1

tar -zxf nlopt-2.4.2.tar.gz
if errorlevel 1 exit 1

copy %RECIPE_DIR%\..\..\common-scripts\msys2-env.bat .
call msys2-env.bat

sh "%RECIPE_DIR%\install_windows_msys2.sh"
if errorlevel 1 exit 1

set NLOPT_HOME=%PREFIX:\=/%

"%R%" CMD INSTALL --build .
if errorlevel 1 exit 1

@rem Add more build steps here, if they are necessary.

@rem See
@rem http://docs.continuum.io/conda/build.html
@rem for a list of environment variables that are set during the build process.
