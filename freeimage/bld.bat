
if defined ProgramFiles(x86) (
  set BDIR=Dist\x64
) else (
  set BDIR=Dist\x32
)

copy %BDIR%\FreeImage.dll %LIBRARY_BIN%\FreeImage-3.17.0.dll
copy %BDIR%\FreeImage.dll %LIBRARY_BIN%\FreeImage.dll
copy %BDIR%\FreeImage.h %LIBRARY_INC%\FreeImage.h
copy %BDIR%\FreeImage.lib %LIBRARY_LIB%\FreeImage.lib
copy C:\Windows\System32\vcomp120.dll %LIBRARY_BIN%\vcomp120.dll || exit "needs VC redist from http://www.microsoft.com/en-us/download/details.aspx?id=40784"
