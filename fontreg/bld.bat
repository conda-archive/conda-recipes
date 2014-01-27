
if "%ARCH%" == "32" (
    set FONTREG_EXE=bin.x86-32\fontreg.exe
) else (
    set FONTREG_EXE=bin.x86-64\fontreg.exe
)

7za x *.7z

mkdir %SCRIPTS%
copy %FONTREG_EXE% %SCRIPTS%\

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
