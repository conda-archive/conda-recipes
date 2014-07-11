#! /bin/sh
set -e

backup_prefix=$PREFIX

ncpus=1
if test -x /usr/bin/getconf; then
    ncpus=$(/usr/bin/getconf _NPROCESSORS_ONLN)
fi

echo "Timestamp" && date
cmake -DOCE_ENABLE_DEB_FLAG:BOOL=OFF \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DOCE_USE_TCL_TEST_FRAMEWORK:BOOL=OFF \
      -DOCE_TESTING:BOOL=ON \
      -DOCE_DRAW:BOOL=OFF \
      -DOCE_VISUALISATION:BOOL=ON \
      -DOCE_OCAF:BOOL=ON \
      -DOCE_DATAEXCHANGE:BOOL=ON \
      -DOCE_USE_PCH:BOOL=ON \
      -DOCE_WITH_GL2PS:BOOL=OFF \
      -DOCE_WITH_FREEIMAGE:BOOL=ON \
      -DOCE_MULTITHREAD_LIBRARY:STRING=NONE \
      -DFREETYPE_LIBRARY=$PREFIX/lib/libfreetype.dylib \
      -DFREETYPE_INCLUDE_DIR_freetype2=$PREFIX/include/freetype2 \
      -DFREETYPE_INCLUDE_DIR_ft2build=$PREFIX/include \
      -DFREEIMAGE_INCLUDE_DIR=$PREFIX/include \
      -DFREEIMAGE_LIBRARY=$PREFIX/lib/libfreeimage.a \
      -DOCE_RPATH_FILTER_SYSTEM_PATHS=ON \
      -DOCE_INSTALL_PREFIX=$PREFIX \
      .


echo ""
echo "Timestamp" && date
echo "Starting build with -j$ncpus ..."
# travis-ci truncates when there are more than 10,000 lines of output.
# Builds generate around 9,000 lines of output, trim them to see test
# results.
make -j$ncpus | grep Built

# Run OCE tests
echo "Timestamp" && date
make test

