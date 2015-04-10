> src\Makevars (
    @echo.PKG_LIBS = -L"%PREFIX%\Library\lib" -llibzmq.lib
    @echo.PKG_CPPFLAGS = -I"%PREFIX%\Library\include"  -I"%SRC_DIR%\inst\cppzmq"
)

"%R%" CMD INSTALL --build .
if errorlevel 1 exit 1

@rem Add more build steps here, if they are necessary.

@rem See
@rem http://docs.continuum.io/conda/build.html
@rem for a list of environment variables that are set during the build process.
