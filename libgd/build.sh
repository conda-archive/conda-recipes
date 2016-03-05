mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DENABLE_PNG=1 \
    -DENABLE_JPEG=1 \
    -DENABLE_TIFF=1 \
    -DENABLE_FREETYPE=1 \
    -DENABLE_WEBP=1 $SRC_DIR

cmake --build . --config Release

cmake --build . --target install

