
if "%ARCH%" == "32" (
    set ELEVATE_EXE=bin.x86-32\elevate.exe
) else (
    set ELEVATE_EXE=bin.x86-64\elevate.exe
)

7za x *.7z

mkdir %SCRIPTS%
copy %ELEVATE_EXE% %SCRIPTS%\

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
