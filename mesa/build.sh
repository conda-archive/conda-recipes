#!/bin/bash

MAKE_JOBS=$CPU_COUNT

./configure CFLAGS='-O2' CXXFLAGS='-O2'    \
            --prefix="$PREFIX"             \
            --enable-texture-float         \
            --enable-gles1                 \
            --enable-gles2                 \
            --enable-osmesa                \
            --enable-xa                    \
            --enable-gbm                   \
            --enable-glx-tls               \
            --with-egl-platforms="drm,x11" \
            --with-gallium-drivers="nouveau,r600,svga,swrast"
make -j $MAKE_JOBS
make install
