@rem Download the nlopt source
python "%RECIPE_DIR%\download_nlopt.py"
if errorlevel 1 exit 1

tar -zxf nlopt-2.4.2.tar.gz
if errorlevel 1 exit 1

bash "%RECIPE_DIR%\install_windows.sh"
if errorlevel 1 exit 1

set NLOPT_HOME="%PREFIX%"

"%R%" CMD INSTALL --build .
if errorlevel 1 exit 1

@rem Add more build steps here, if they are necessary.

@rem See
@rem http://docs.continuum.io/conda/build.html
@rem for a list of environment variables that are set during the build process.
