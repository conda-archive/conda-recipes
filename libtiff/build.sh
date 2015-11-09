#!/bin/bash

# Install non-lib artifacts to these special 
# directories so we can cleanly delete them later.
TIFF_BIN="${PREFIX}/tiff-bin"
TIFF_SHARE="${PREFIX}/tiff-share"
TIFF_DOC="${PREFIX}/tiff-doc"

mkdir "${TIFF_BIN}" "${TIFF_SHARE}" "${TIFF_DOC}"

# Pass explicit paths to the prefix for each dependency.
./configure --prefix="${PREFIX}" \
            --with-zlib-include-dir="${PREFIX}/include" \
            --with-zlib-lib-dir="${PREFIX}/lib" \
            --with-jpeg-include-dir="${PREFIX}/include" \
            --with-jpeg-lib-dir="${PREFIX}/lib" \
            --with-jbig-include-dir="${PREFIX}/include" \
            --with-jbig-lib-dir="${PREFIX}/lib" \
            --with-lzma-include-dir="${PREFIX}/include" \
            --with-lzma-lib-dir="${PREFIX}/lib" \
            --bindir="${TIFF_BIN}" \
            --datarootdir="${TIFF_SHARE}" \
            --docdir="${TIFF_DOC}" \
##

make -j"${CPU_COUNT}"
make install

rm -rf "${TIFF_BIN}" "${TIFF_SHARE}" "${TIFF_DOC}"

# For some reason --docdir is not respected above.
rm -rf "${PREFIX}/share/doc/tiff*"
