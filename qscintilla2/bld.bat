:: Set QMAKESPEC to the appropriate MSVC compiler
set QMAKESPEC=%LIBRARY_PREFIX%\mkspecs\win32-msvc-default

:: Go to the source folder and enter the Qt4Qt5 dir
cd %SRC_DIR%\Qt4Qt5
:: Use qmake to generate a make file
%LIBRARY_BIN%\qmake qscintilla.pro
:: Build and install
nmake
nmake install

:: Python bindings
:: Go into the Python folder
cd %SRC_DIR%\Python
:: Use configure.py to generate a MAKEFILE
%PYTHON% configure.py
:: Build and install
nmake
nmake install
:: The qscintilla2.dll ends up in Anaconda's lib dir, where Python
:: can't find it for import. Copy it to the bin dir
:: (as indicated at http://pyqt.sourceforge.net/Docs/QScintilla2/)
copy %LIBRARY_LIB%\qscintilla2.dll %LIBRARY_BIN%