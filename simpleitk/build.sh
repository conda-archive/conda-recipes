#!/bin/bash

CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu || 1)
if [ `uname` == Darwin ]; then
    SO_EXT='dylib'
else
    SO_EXT='so'
fi

BUILD_DIR=${SRC_DIR}/build
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}


cmake \
    -D "CMAKE_CXX_FLAGS:STRING=-fvisibility=hidden -fvisibility-inlines-hidden ${CFLAGS}" \
    -D "CMAKE_C_FLAGS:STRING=-fvisibility=hidden ${CXXFLAGS}" \
    -D "CMAKE_INSTALL_PREFIX=:PATH=$PREFIX" \
    -D CMAKE_OSX_DEPLOYMENT_TARGET:STRING=${MACOSX_DEPLOYMENT_TARGET} \
    -D SimpleITK_BUILD_DISTRIBUTE:BOOL=ON \
    -D SimpleITK_BUILD_STRIP:BOOL=ON \
    -D CMAKE_BUILD_TYPE:STRING=RELEASE \
    -D BUILD_SHARED_LIBS:BOOL=OFF \
    -D WRAP_CSHARP:BOOL=OFF \
    -D WRAP_LUA:BOOL=OFF \
    -D WRAP_PYTHON:BOOL=ON \
    -D WRAP_JAVA:BOOL=OFF \
    -D WRAP_CSHARP:BOOL=OFF \
    -D WRAP_TCL:BOOL=OFF \
    -D WRAP_R:BOOL=OFF \
    -D WRAP_RUBY:BOOL=OFF \
    -D "PYTHON_EXECUTABLE:FILEPATH=${PYTHON}" \
    -D "PYTHON_INCLUDE_PATH:PATH=$PREFIX/include/python${PY_VER}" \
    -D "PYTHON_LIBRARY:FILEPATH=$PREFIX/lib/libpython${PY_VER}.${SO_EXT}" \
    "${SRC_DIR}/SuperBuild"

make -j ${CORES}
cd ${BUILD_DIR}/SimpleITK-build/Wrapping
${PYTHON} PythonPackage/setup.py install


