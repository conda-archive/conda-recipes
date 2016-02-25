swig.exe 2> NUL
if %ERRORLEVEL%==9009 GOTO Swig_missing

REM Copy any licenced source files the optimizers
REM SET SNOPT_DIR="z:\snopt7"
REM IF EXIST %SNOPT_DIR% ( xcopy %SNOPT_DIR%\src\* "%SRC_DIR%"\pyOpt\pySNOPT\source\* /S/Y/I/Q )

%SYS_PYTHON% setup.py install --compiler=mingw32 --prefix=%PREFIX%

for %%x in (libgfortran-3.dll libquadmath-0.dll) do (
   copy %SYS_PREFIX%\Scripts\%%x %SP_DIR%\pyopt\
   if errorlevel 1 exit 1
)

GOTO End

:Swig_missing
Echo "Swig.exe is missing in PATH"

:End