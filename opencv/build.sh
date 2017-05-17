#!/bin/bash

PY_MAJOR=`${PREFIX}/bin/python -c "import sys; print(sys.version_info.major)"`
PY_MINOR=`${PREFIX}/bin/python -c "import sys; print(sys.version_info.minor)"`

EXT="so"
SDK=""

if [ `uname` == Darwin ]; then
    EXT="dylib"
    SDK="-DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk"
fi

git clone https://github.com/Itseez/opencv_contrib
cd opencv_contrib
git checkout tags/${PKG_VERSION}
# this patch only strictly necessary on Mac, but benign elsewhere.  Added for Version 3.0.0.
# git apply ${RECIPE_DIR}/line_float_cvt.patch
cd ..

mkdir build
cd build
cmake                                                                                   \
    -DCMAKE_BUILD_TYPE=Release                                                          \
    -DBUILD_TESTS=false                                                                 \
    -DBUILD_PERF_TESTS=false                                                            \
    -DPYTHON${PY_MAJOR}_EXECUTABLE=${PREFIX}/bin/python                                 \
    -DPYTHON_INCLUDE_DIR=$(python -c "from __future__ import print_function; from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
    -DPYTHON_PACKAGES_PATH=${PREFIX}/lib/python${PY_MAJOR}.${PY_MINOR}/site-packages/   \
    -DCMAKE_INSTALL_PREFIX=$PREFIX                                                      \
    -DWITH_CUDA=OFF                                                                     \
    -DWITH_AVFOUNDATION=OFF                                                             \
    -DWITH_FFMPEG=ON                                                                    \
    -DWITH_TBB=ON                                                                       \
    -DWITH_VTK=OFF                                                                      \
    -DJPEG_INCLUDE_DIR:PATH=$PREFIX/include                                             \
    -DJPEG_LIBRARY:FILEPATH=$PREFIX/lib/libjpeg.${EXT}                                  \
    -DTIFF_INCLUDE_DIR:PATH=$PREFIX/include                                             \
    -DTIFF_LIBRARY:FILEPATH=$PREFIX/lib/libtiff.${EXT}                                  \
    -DPNG_INCLUDE_DIR:PATH=$PREFIX/include                                              \
    -DPNG_LIBRARY:FILEPATH=$PREFIX/lib/libpng.${EXT}                                    \
    -DZLIB_INCLUDE_DIR:PATH=$PREFIX/include                                             \
    -DZLIB_LIBRARY:FILEPATH=$PREFIX/lib/libz.${EXT}                                     \
    -DOPENCV_EXTRA_MODULES_PATH=${SRC_DIR}/opencv_contrib/modules                       \
    -DCMAKE_SKIP_RPATH:bool=ON                                                          \
    ${SDK}                                                                              \
    ..

make -j${CPU_COUNT}
make install
