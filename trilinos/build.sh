#!/bin/bash

if [ `uname` == Darwin ]; then
    SO_EXT='dylib'
else
    SO_EXT='so'
fi

mkdir build
cd build

cmake \
    -D CMAKE_BUILD_TYPE:STRING=RELEASE \
    -D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE \
    -D DART_TESTING_TIMEOUT:STRING=600 \
    -D Trilinos_ENABLE_Fortran:BOOL=OFF \
    -D Trilinos_ENABLE_TESTS:BOOL=OFF \
    -D Trilinos_ENABLE_DEBUG:BOOL=OFF \
    -D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
    -D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
    -D Trilinos_ENABLE_PyTrilinos:BOOL=ON \
    -D Trilinos_ENABLE_Teuchos:BOOL=ON \
    -D Trilinos_ENABLE_Epetra:BOOL=OFF \
    -D Trilinos_ENABLE_Trutils:BOOL=OFF \
    -D Trilinos_ENABLE_EpetraExt:BOOL=OFF \
    -D Trilinos_ENABLE_Isorropia:BOOL=OFF \
    -D Trilinos_ENABLE_AztecOO:BOOL=OFF \
    -D Trilinos_ENABLE_Galeri:BOOL=OFF \
    -D Trilinos_ENABLE_Amesos:BOOL=OFF \
    -D Trilinos_ENABLE_Ifpack:BOOL=OFF \
    -D Trilinos_ENABLE_Komplex:BOOL=OFF \
    -D Trilinos_ENABLE_Anasazi:BOOL=OFF \
    -D Trilinos_ENABLE_ML:BOOL=OFF \
    -D Trilinos_ENABLE_NOX:BOOL=OFF \
    -D Trilinos_ENABLE_Pliris:BOOL=OFF \
    -D BUILD_SHARED_LIBS:BOOL=ON \
    -D SWIG_EXECUTABLE:FILEPATH=$PREFIX/bin/swig \
    -D PYTHON_EXECUTABLE:FILEPATH=$PREFIX/bin/python${PY_VER} \
    -D PYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python${PY_VER} \
    -D PYTHON_LIBRARY:FILEPATH=$PREFIX/lib/libpython${PY_VER}.${SO_EXT} \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    ..

make
make install
