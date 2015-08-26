:: set path to find resources shipped with qt-5
:: see http://doc-snapshot.qt-project.org/qt5-5.4/windows-building.html
set PATH=%SRC_DIR%\qtbase\bin;%SRC_DIR%\gnuwin32\bin;%PATH%
set QMAKESPEC=win32-msvc2010

:: make sure we can find ICU and openssl:
set INCLUDE=%PREFIX%\Library\include;C:\OpenSSL-Win64\include;%INCLUDE%
set LIB=%PREFIX%\Library\lib;C:\OpenSSL-Win64\lib;%LIB%
set PATH=%PREFIX%\Scripts;C:\OpenSSL-Win64\bin;%PATH%

:: make sure we can find sqlite3:
set SQLITE3SRCDIR=%SRC_DIR%\qtbase\src\3rdparty\sqlite

:: See http://doc-snapshot.qt-project.org/qt5-5.4/windows-requirements.html

:: this needs to be CALLed due to an exit statement at the end of configure:
CALL configure -platform win32-msvc2010 ^
      -prefix %PREFIX% ^
      -libdir %PREFIX%\Library\lib\qt5 ^
      -bindir %PREFIX%\Scripts ^
      -headerdir %PREFIX%\Library\include\qt5 ^
      -archdatadir %PREFIX%\Library\lib\qt5 ^
      -datadir %PREFIX%\Library\share\qt5 ^
      -release ^
      -shared ^
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
      -icu ^
      -opengl dynamic

:: jom is nmake alternative with multicore support, uses all cores by default
jom
jom install

:: remove docs, phrasebooks, translations
rmdir %PREFIX%\Library\share\qt5 /s /q

%PYTHON% %RECIPE_DIR%\patch_prefix_files.py
