:: change qt.conf name for qt4 coexistence
patch -p1 <%RECIPE_DIR%/qt5_conf.patch

:: set path to find resources shipped with qt-5
:: see https://doc.qt.io/qt-5/windows-building.html
set PATH=%SRC_DIR%\qtbase\bin;%SRC_DIR%\gnuwin32\bin;%PATH%

:: make sure we can find sqlite3:
set SQLITE3SRCDIR=%SRC_DIR%\qtbase\src\3rdparty\sqlite

:: See https://doc.qt.io/qt-5/windows-requirements.html
set QMAKESPEC=win32-msvc2015

:: this needs to be CALLed due to an exit statement at the end of configure:
CALL configure ^
    -prefix %PREFIX%\Library ^
    -bindir %PREFIX%\Library\bin\qt5 ^
    -headerdir %PREFIX%\Library\include\qt5 ^
    -libdir %PREFIX%\Library\lib\qt5 ^
    -archdatadir %PREFIX%\Library\lib\qt5 ^
    -datadir %PREFIX%\Library\share\qt5 ^
    -I %PREFIX%\Library\include ^
    -L %PREFIX%\Library\lib ^
    -opensource ^
    -confirm-license ^
    -release ^
    -shared ^
    -no-warnings-are-errors ^
    -no-separate-debug-info ^
    -nomake examples ^
    -nomake tests ^
    -skip enginio ^
    -skip qtimageformats ^
    -opengl dynamic ^
    -qt-pcre ^
    -icu
if errorlevel 1 exit 1

:: jom is nmake alternative with multicore support, uses all cores by default
jom
if errorlevel 1 exit 1
jom install
if errorlevel 1 exit 1

:: add -qt5 suffix for qt4 coexistence
for %%G in (%PREFIX%\Library\bin\qt5\*.dll) do move %%G %PREFIX%\Library\bin\
for %%G in (%PREFIX%\Library\bin\qt5\*.exe) do echo %%G %%* >%PREFIX%\Library\bin\%%~nG-qt5.bat
if errorlevel 1 exit 1

:: remove docs, phrasebooks, translations
rmdir %PREFIX%\Library\share\qt5 /s /q
if errorlevel 1 exit 1

:: prl files include %PREFIX% in escaped form, i.e. using \\.
:: conda does not recognize those, so we have to help it.
%PYTHON% %RECIPE_DIR%\patch_prl_prefix.py
if errorlevel 1 exit 1

:: Add qt.conf file to the package to make it fully relocatable
copy %RECIPE_DIR%\qt5_win.conf %PREFIX%\qt5.conf
echo Prefix = . >>%PREFIX%\qt5.conf

copy %RECIPE_DIR%\qt5_win.conf %PREFIX%\Library\bin\qt5.conf
echo Prefix = ../.. >>%PREFIX%\Library\bin\qt5.conf
