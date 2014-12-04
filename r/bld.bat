@rem This is relative apparently
set TMPDIR=.

@rem The path where the Rtools installed the R stuff. Should be a directory
@rem with a Tcl directory in it.
set R_HOME=C:\R64

cd src\gnuwin32
make
