rem if "%ARCH%"=="32" (
rem     curl -SLO http://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/openjdk-1.7.0-u80-unofficial-windows-i586-image.zip
rem     unzip openjdk-1.7.0-u80-unofficial-windows-i586-image.zip
rem     set JAVA_HOME=%CD%\openjdk-1.7.0-u80-unofficial-windows-i586-image
rem ) else (
rem     curl -SLO http://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/openjdk-1.7.0-u80-unofficial-windows-amd64-image.zip
rem     unzip openjdk-1.7.0-u80-unofficial-windows-amd64-image.zip
rem     set JAVA_HOME=%CD%\openjdk-1.7.0-u80-unofficial-windows-amd64-image
rem )

"%R%" CMD INSTALL --build .
if errorlevel 1 exit 1

@rem Add more build steps here, if they are necessary.

@rem See
@rem http://docs.continuum.io/conda/build.html
@rem for a list of environment variables that are set during the build process.
