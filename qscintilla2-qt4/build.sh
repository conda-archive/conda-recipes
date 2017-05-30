#!/bin/bash
BIN=$PREFIX/bin

# Set build specs depending on current platform (Mac OS X or Linux)
if [ `uname` == Darwin ]; then
	BUILD_SPEC=macx-llvm
else
	BUILD_SPEC=linux-g++
fi

# Go to Qscintilla source dir and then to its Qt4Qt5 folder.
cd ${SRC_DIR}/Qt4Qt5
# Build the makefile with qmake, specify llvm as the compiler
# The normal g++ compiler causes an __Unwind_Resume error at linking phase
${BIN}/qmake qscintilla.pro -spec ${BUILD_SPEC}
# Build Qscintilla
make
# and install it
make install

## Build Python module ##

# Go to python folder
cd ${SRC_DIR}/Python
# Configure compilation of Python Qsci module
${PYTHON} configure.py --qmake=${BIN}/qmake --sip=${BIN}/sip --qsci-incdir=${PREFIX}/include --qsci-libdir=${PREFIX}/lib --spec=${BUILD_SPEC} --no-qsci-api 
# make it
make

# On OSX: Change reference from libQsci.dylib to Qsci.so (otherwise anaconda linker crashes)
if [ `uname` == Darwin ]; then
	install_name_tool -id Qsci.so Qsci.so
fi

# Install QSci.so to the site-packages/PyQt4 folder
make install