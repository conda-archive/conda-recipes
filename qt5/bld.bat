:: may need to change these depending on environment:
CALL "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64
::CALL "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" amd64

:: set path to find resources shipped with qt-5:
set PATH=%SRC_DIR%\gnuwin32\bin;%PATH%

:: make sure we can find ICU and openssl:
set INCLUDE=%PREFIX%\include;C:\OpenSSL-Win64\include;%INCLUDE%
set LIB=%PREFIX%\libs;C:\OpenSSL-Win64\lib;%LIB%
set PATH=C:\OpenSSL-Win64\bin;%PATH%

:: make sure we can find sqlite3:
set SQLITE3SRCDIR=%SRC_DIR%\qtbase\src\3rdparty\sqlite

:: this needs to be CALLed due to an exit statement at the end of configure:
CALL configure -platform win32-msvc2010 ^
      -prefix %PREFIX%\Library ^
      -libdir %PREFIX%\Library\lib ^
      -bindir %PREFIX%\Scripts ^
      -headerdir %PREFIX%\Library\include\qt5 ^
      -archdatadir %PREFIX%\Library\lib\qt5 ^
      -datadir %PREFIX%\Library\share\qt5 ^
      -release ^
      -opensource ^
      -confirm-license ^
      -no-warnings-are-errors ^
      -no-separate-debug-info ^
      -nomake examples ^
      -nomake tests ^
      -fontconfig ^
      -qt-libpng ^
      -qt-zlib ^
      -qt-libjpeg ^
      -opengl desktop

:: jom is nmake alternative with multicore support, uses all cores by default
jom
nmake install

:: remove docs, phrasebooks, translations
rmdir %PREFIX%\Library\share\qt5 /s /q
