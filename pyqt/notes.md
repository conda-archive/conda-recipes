== Windows ==

Building the pyqt conda package for windows requires special preparation. The
recipe assumes you have run the executables from Riverbank Computing and
installed into `C:\staging`. This directory should not exist before installing
to that location, i.e., it should not be a working python environment. The
pyqt recipe's bld.bat just copies the contents of `C:\staging` into our conda
build environment.