== Windows ==

Building the pyqt conda package for windows requires special
preparation. The recipe assumes you have run the executables from
Riverbank Computing and installed into `C:\staging`. This directory
should not exist before installing to that location, i.e., it should
not be a working python environment. The pyqt recipe's bld.bat just
copies the contents of `C:\staging` into our conda build environment.

An alternative approach would be to add a Qt(4) package for windows,
but then we would need to patch either Qt4 or Qt5 to prevent
collisions of executables (like 'designer' and 'qmake', the DLLs at
least do not collide), and also PyQt4 or PyQt5 would have to be
patched to find the renamed executables.

Another approach to pyqt would be to build PyQt4 against Qt5 for
python3. This would allow building PyQt4 from source on windows, but
based on the documentation at
http://pyqt.sourceforge.net/Docs/PyQt4/qt_v5.html , this approach
seems to be undesirable in practice, since there could be cases of
PyQt4-Qt4 code using old-style signals that would need to be altered
to run with PyQt4-Qt5. And worse, there is the potential of developing
code with PyQt4-Qt5 that would not run with PyQt4-Qt4, since PyQt4-Qt5
exposes methods introduced in Qt5 for classes that existed in Qt4.
