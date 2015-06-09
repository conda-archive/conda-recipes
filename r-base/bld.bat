@rem See notes.md for more information about all of this.

@rem Compile the launcher

@rem XXX: Should we build Rgui with -DGUI=1 -mwindows?  The only difference is
@rem that that it doesn't block the terminal, but we also can't get the return
@rem value for the conda build tests.
gcc -DGUI=0 -O -s -m"%ARCH%" -o launcher.exe "%RECIPE_DIR%\launcher.c"
if errorlevel 1 exit 1

@rem Install the launcher

mkdir "%PREFIX%\Scripts"
if errorlevel 1 exit 1

copy launcher.exe "%PREFIX%\Scripts\R.exe"
if errorlevel 1 exit 1

copy launcher.exe "%PREFIX%\Scripts\Rcmd.exe"
if errorlevel 1 exit 1

copy launcher.exe "%PREFIX%\Scripts\RSetReg.exe"
if errorlevel 1 exit 1

copy launcher.exe "%PREFIX%\Scripts\Rfe.exe"
if errorlevel 1 exit 1

copy launcher.exe "%PREFIX%\Scripts\Rgui.exe"
if errorlevel 1 exit 1

copy launcher.exe "%PREFIX%\Scripts\Rscript.exe"
if errorlevel 1 exit 1

copy launcher.exe "%PREFIX%\Scripts\Rterm.exe"
if errorlevel 1 exit 1

@rem XXX: Should we skip this one?
copy launcher.exe "%PREFIX%\Scripts\open.exe"
if errorlevel 1 exit 1

@rem This is relative apparently
set TMPDIR=.

@rem The path where the Rtools installed the R stuff. Should be a directory
@rem with a Tcl directory in it.
if "%ARCH%"=="32" (
    set RTOOLS=C:\R
) else (
    set RTOOLS=C:\R64
)

xcopy /S /E "%RTOOLS%\Tcl" "%SRC_DIR%\Tcl\"
if errorlevel 1 exit 1

@rem R requires sources for libpng, libjpeg, and libtiff to compile.
cd src\gnuwin32\bitmap

mkdir libpng
if errorlevel 1 exit 1

mkdir jpeg-9
if errorlevel 1 exit 1

mkdir libtiff
if errorlevel 1 exit 1

xcopy /S /E "%RTOOLS%\src\gnuwin32\bitmap\libpng" libpng
if errorlevel 1 exit 1

xcopy /S /E "%RTOOLS%\src\gnuwin32\bitmap\jpeg-9" jpeg-9
if errorlevel 1 exit 1

xcopy /S /E "%RTOOLS%\src\gnuwin32\bitmap\libtiff" libtiff
if errorlevel 1 exit 1

cd "%SRC_DIR%"

@rem Various things that are needed to make the docs work.
copy doc\html\logo.jpg %TMPDIR%
if errorlevel 1 exit 1

@rem Now actually compile it

@rem For whatever reason, these files aren't put in the right place.  They
@rem files won't exist the first time we try to build, so let's "build" it
@rem once (without the 'if errorlevel 1 exit 1') and then copy the files after
@rem it inevitably fails and build it again.
cd src\gnuwin32

if "%ARCH%"=="64" (
    @rem This is the copied version of MkRules.dist with WIN = 32 changed to WIN =
    @rem 64 and BINDIR64 set to empty and MULTI = 64.
    copy "%RECIPE_DIR%\MkRules.local" .
)
make distribution
cd "%SRC_DIR%"

copy library\graphics\help\figures\pch.pdf doc\manual\pch.pdf
if errorlevel 1 exit 1

copy library\graphics\help\figures\mai.pdf doc\manual\mai.pdf
if errorlevel 1 exit 1

copy library\graphics\help\figures\oma.pdf doc\manual\oma.pdf
if errorlevel 1 exit 1

cd "%SRC_DIR%\src\gnuwin32"
make distribution
if errorlevel 1 exit 1

@rem And finally collect everything together.
cd installer
make imagedir
if errorlevel 1 exit 1

@rem And install it
xcopy /S /E R-3.1.3 "%PREFIX%\R\"
if errorlevel 1 exit 1
