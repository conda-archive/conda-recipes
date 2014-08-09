
if "%ARCH%"=="32" (
    set TARGET="Release|Win32"
    set BUILD_PREFIX=apr\Release
) else (
    set TARGET="Release|x64"
    set BUILD_PREFIX=apr\x64\Release
)

devenv apr-util\aprutil.sln /build %TARGET% /project libapr
if errorlevel 1 exit 1

copy %BUILD_PREFIX%\libapr-1.dll %LIBRARY_BIN%\
copy %BUILD_PREFIX%\libapr-1.pdb %LIBRARY_BIN%\
copy %BUILD_PREFIX%\libapr-1.lib %LIBRARY_LIB%\

xcopy apr\include\*.h %LIBRARY_INC%\

mkdir %LIBRARY_INC%\arch\win32

copy apr\include\arch\apr_private_common.h %LIBRARY_INC%\arch\
xcopy apr\include\arch\win32\*.h %LIBRARY_INC%\arch\win32\

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
