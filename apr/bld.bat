set "APR_VER=1.5.2"
set "APU_VER=1.5.4"
set "API_VER=1.2.1"

curl http://www.interior-dsgn.com/apache/apr/apr-%APR_VER%-win32-src.zip -o apr.zip
curl http://www.interior-dsgn.com/apache/apr/apr-util-%APU_VER%-win32-src.zip -o apr-util.zip
curl http://www.interior-dsgn.com/apache/apr/apr-iconv-%API_VER%-win32-src-r2.zip -o apr-iconv.zip

7za x apr.zip
7za x apr-util.zip
7za x apr-iconv.zip

MOVE apr-%APR_VER% apr
MOVE apr-util-%APU_VER% apr-util
MOVE apr-iconv-%API_VER% apr-iconv

set BUILD_MODE=Release

if "%ARCH%"=="32" (
    set PLATFORM=Win32
) else (
    set PLATFORM=x64
    set XML_SUBDIR=x64
)

:: APR creates 32 bit builds in the "Debug" and "Release" directories
:: but 64 bit builds in the "x64\Debug" or "x64\Release" directories.
SET BUILD_DIR=%BUILD_MODE%
IF %PLATFORM% == x64 SET BUILD_DIR=x64\%BUILD_DIR%

:: Build the APR library.
PUSHD apr
NMAKE /nologo /f libapr.mak CFG="libapr - %PLATFORM% %BUILD_MODE%" || (POPD & ECHO Failed to build APR library & EXIT /b 1)
POPD
COPY apr\%BUILD_DIR%\libapr-1.dll %LIBRARY_BIN%\ || (ECHO Failed to copy APR binary & EXIT /b 1)
COPY apr\%BUILD_DIR%\libapr-1.lib %LIBRARY_LIB%\ || (ECHO Failed to copy APR link library & EXIT /b 1)
IF EXIST apr\%BUILD_DIR%\libapr-1.pdb COPY apr\%BUILD_DIR%\libapr-1.pdb %LIBRARY_BIN%\

:: Build the APR-iconv library.
PUSHD apr-iconv
NMAKE /nologo /f libapriconv.mak CFG="libapriconv - %PLATFORM% %BUILD_MODE%" || (POPD & ECHO Failed to build APR-iconv library & EXIT /b 1)
POPD
:: Workaround for "LINK : fatal error LNK1181: cannot open input file ..\Debug\libapriconv-1.lib".
IF %PLATFORM% == x64 XCOPY /Y apr-iconv\x64\%BUILD_MODE% apr-iconv
COPY apr-iconv\%BUILD_DIR%\libapriconv-1.dll %LIBRARY_BIN%\
COPY apr-iconv\%BUILD_DIR%\libapriconv-1.lib %LIBRARY_LIB%\
IF EXIST apr-iconv\%BUILD_DIR%\libapriconv-1.pdb COPY apr-iconv\%BUILD_DIR%\libapriconv-1.pdb %LIBRARY_BIN%\
:: TODO I'm not sure how or why but apparently the above does not build the
:: *.so files, instead they are built by the apr-util section below. This is
:: why the *.so files are copied after building apr-util instead of here...

:: Build the APR-util library.
IF "%PLATFORM%" == "x64" (
  :: I haven't a clue why this is needed, but it certainly helps :-)
  TYPE apr-util\include\apu.hw > apr-util\include\apu.h
)
PUSHD apr-util
NMAKE /nologo /f libaprutil.mak CFG="libaprutil - %PLATFORM% %BUILD_MODE%" || (POPD & ECHO Failed to build APR-util library & EXIT /b 1)
POPD
COPY apr-util\%BUILD_DIR%\libaprutil-1.dll %LIBRARY_BIN%\
COPY apr-util\%BUILD_DIR%\libaprutil-1.lib %LIBRARY_LIB%\
xcopy apr-util\include\*.h %LIBRARY_INC%\
xcopy apr-util\xml\expat\lib\*.h %LIBRARY_INC%\
COPY apr-util\xml\expat\lib\%XML_SUBDIR%\LibR\xml.lib %LIBRARY_LIB%\
IF EXIST apr-util\%BUILD_DIR%\libaprutil-1.pdb COPY apr-util\%BUILD_DIR%\libaprutil-1.pdb %LIBRARY_BIN%\

:: TODO As explained above, apr-util builds the apr-iconv *.so files... 
IF NOT EXIST %LIBRARY_BIN%\iconv MKDIR %LIBRARY_BIN%\iconv
COPY apr-iconv\%BUILD_MODE%\iconv\*.so %LIBRARY_BIN%\iconv
COPY apr-iconv\%BUILD_MODE%\iconv\*.pdb %LIBRARY_BIN%\iconv

xcopy apr\include\*.h %LIBRARY_INC%\

mkdir %LIBRARY_INC%\arch\win32

copy apr\include\arch\apr_private_common.h %LIBRARY_INC%\arch\
xcopy apr\include\arch\win32\*.h %LIBRARY_INC%\arch\win32\

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
