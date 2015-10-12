#!/bin/bash

mkdir build
cd build

if [ `uname` == Linux ]; then
    CC=gcc44
    CXX=g++44
    PY_LIB="libpython${PY_VER}.so"

    cmake .. \
        -DCMAKE_C_COMPILER=$CC \
        -DCMAKE_CXX_COMPILER=$CXX \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
        -DCMAKE_INSTALL_RPATH:STRING="${PREFIX}/lib" \
        -DBUILD_DOCUMENTATION=OFF \
        -DVTK_HAS_FEENABLEEXCEPT=OFF \
        -DBUILD_TESTING=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_SHARED_LIBS=ON \
        -DVTK_WRAP_PYTHON=ON \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_INCLUDE_PATH=${PREFIX}/include/python${PY_VER} \
        -DPYTHON_LIBRARY=${PREFIX}/lib/${PY_LIB} \
        -DVTK_INSTALL_PYTHON_MODULE_DIR=${SP_DIR} \
        -DVTK_USE_OFFSCREEN=ON \
        -DModule_vtkRenderingMatplotlib=ON \
        -DVTK_USE_X=OFF \
        -DOPENGL_INCLUDE_DIR=${PREFIX}/include \
        -DOPENGL_gl_LIBRARY=${PREFIX}/lib/libOSMesa.so \
        -DVTK_OPENGL_HAS_OSMESA=ON \
        -DOSMESA_INCLUDE_DIR=${PREFIX}/include \
        -DOSMESA_LIBRARY=${PREFIX}/lib/libOSMesa.so
fi

if [ `uname` == Darwin ]; then
    CC=cc
    CXX=c++
    PY_LIB="libpython${PY_VER}.dylib"

    cmake .. \
        -DCMAKE_C_COMPILER=$CC \
        -DCMAKE_CXX_COMPILER=$CXX \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DCMAKE_INSTALL_RPATH:STRING="$PREFIX/lib" \
        -DBUILD_DOCUMENTATION=OFF \
        -DVTK_HAS_FEENABLEEXCEPT=OFF \
        -DBUILD_TESTING=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_SHARED_LIBS=ON \
        -DVTK_WRAP_PYTHON=ON \
        -DPYTHON_EXECUTABLE=${PYTHON} \
        -DPYTHON_INCLUDE_PATH=${PREFIX}/include/python${PY_VER} \
        -DPYTHON_LIBRARY=${PREFIX}/lib/${PY_LIB} \
        -DVTK_INSTALL_PYTHON_MODULE_DIR=${SP_DIR} \
        -DVTK_USE_OFFSCREEN=ON \
        -DModule_vtkRenderingMatplotlib=ON \
        -DVTK_USE_X=OFF
fi

make -j${CPU_COUNT}
make install
