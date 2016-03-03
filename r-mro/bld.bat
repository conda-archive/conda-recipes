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

@rem I had a go at building from source on Windows
@rem It's not ready yet (by a long stretch).
@rem If meta.yml sets a git hash then build it.
if "%GIT_FULL_HASH%" == "" goto repack_binary

copy %RECIPE_DIR%\build.sh .
bash build.sh
if errorlevel 1 exit 1

:repack_binary

curl -SLO http://constexpr.org/innoextract/files/innoextract-1.5-windows.zip
7za x -y innoextract-1.5-windows.zip
if errorlevel 1 exit 1
innoextract -e MRO-3.2.3-win.exe
if errorlevel 1 exit 1

mkdir -p %PREFIX%\R
if errorlevel 1 exit 1

cp -Rv app/* %PREFIX%/R
if errorlevel 1 exit 1

cp app/COPYING %SRC_DIR%
if errorlevel 1 exit 1

@rem We can't do this legally anyway, instead we might want to set registry keys
@rem and give the user information on the command line and/or in a blog post.
@rem curl -SLO https://mran.revolutionanalytics.com/install/mro/3.2.3/RevoMath-3.2.3.exe
@rem innoextract -e RevoMath-3.2.3.exe
@rem if errorlevel 1 exit 1

@rem So that people who download MKL have an easier time of it,
@rem we could write a post-link.bat to do:
@rem reg.exe set HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MRO for Windows 3.2.3_is1\InstallLocation %PREFIX%
