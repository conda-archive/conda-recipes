#!/bin/bash

set -x
set -e
# Based on https://github.com/jyypma/nloptr/blob/master/INSTALL.windows

R_HOME="$PREFIX/R"
if [ $ARCH == "32" ]; then
    export R_ARCH="i386"
else
    export R_ARCH="x64"
fi

cd nlopt-2.4.2

# The ones that come with nlopt are too old for Windows 7
mv "$RECIPE_DIR/config.guess" .
mv "$RECIPE_DIR/config.sub" .

# Create directory for output
mkdir "${PREFIX}/${R_ARCH}"

# Get R compilers and flags
CC=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config CC`
CFLAGS=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config CFLAGS`

CPP=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config CPP`
CPPFLAGS=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config CPPFLAGS`

CXX=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config CXX`
CXXFLAGS=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config CXXFLAGS`

CXXCPP=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config CXXCPP`

F77=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config F77`
FFLAGS=`"${R_HOME}/bin/${R_ARCH}/R.exe" CMD config FFLAGS`

echo "./configure --prefix=\"${PREFIX}/${R_ARCH}\" --disable-shared --enable-static --without-octave --without-matlab --without-guile --without-python --with-cxx CC=\"${CC}\" ADD_CFLAGS=\"${CFLAGS}\" CPP=\"${CPP}\" ADD_CPPFLAGS=\"${CPPFLAGS}\" CXX=\"${CXX}\" ADD_CXXFLAGS=\"${CXXFLAGS}\" CXXCPP=\"${CXXCPP}\" F77=\"${F77}\" ADD_FFLAGS=\"${FFLAGS}\""

# Configure
./configure --prefix="${PREFIX}/${R_ARCH}" --disable-shared --enable-static --without-octave --without-matlab --without-guile --without-python --with-cxx CC="${CC}" ADD_CFLAGS="${CFLAGS}" CPP="${CPP}" ADD_CPPFLAGS="${CPPFLAGS}" CXX="${CXX}" ADD_CXXFLAGS="${CXXFLAGS}" CXXCPP="${CXXCPP}" F77="${F77}" ADD_FFLAGS="${FFLAGS}"

# Compile
make
make install
