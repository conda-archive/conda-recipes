@rem See notes.md for more information about all of this.

@rem This is relative apparently
set TMPDIR=.

@rem The path where the Rtools installed the R stuff. Should be a directory
@rem with a Tcl directory in it.
set RTOOLS=C:\R

xcopy /S /E "%RTOOLS%\Tcl" "%SRC_DIR%\Tcl\"
if errorlevel 1 exit 1

@rem R requires sources for libpng, libjpeg, and libtiff to compile.
cd src\gnuwin32\bitmap
python "%RECIPE_DIR%\download_win_libs.py"
if errorlevel 1 exit 1

tar -zxf libpng-1.6.15.tar.gz
if errorlevel 1 exit 1

mv libpng-1.6.15 libpng
if errorlevel 1 exit 1

tar -zxf jpegsrc.v9a.tar.gz
if errorlevel 1 exit 1

mv jpeg-9a jpeg-9
if errorlevel 1 exit 1

tar -zxf tiff-4.0.3.tar.gz
if errorlevel 1 exit 1

mv tiff-4.0.3/libtiff .
if errorlevel 1 exit 1

rm -rf tiff-4.0.3
if errorlevel 1 exit 1

cd "%SRC_DIR%"

@rem Various things that are needed to make the docs work.
cp doc\html\logo.jpg %TMPDIR%
if errorlevel 1 exit 1

@rem Now actually compile it

@rem For whatever reason, these files aren't put in the right place.  They
@rem files won't exist the first time we try to build, so let's "build" it
@rem once (without the 'if errorlevel 1 exit 1') and then copy the files after
@rem it inevitably fails and build it again.
cd src\gnuwin32
make distribution
cd "%SRC_DIR%"

cp library\graphics\help\figures\pch.pdf doc\manual\
if errorlevel 1 exit 1

cp library\graphics\help\figures\mai.pdf doc\manual\
if errorlevel 1 exit 1

cp library\graphics\help\figures\oma.pdf doc\manual\
if errorlevel 1 exit 1

cd "%SRC_DIR%\src\gnuwin32"
make distribution
if errorlevel 1 exit 1

@rem And finally collect everything together.
cd installer
make imagedir
if errorlevel 1 exit 1

@rem And install it
xcopy /S /E R-3.1.2 "%PREFIX%\R\"
