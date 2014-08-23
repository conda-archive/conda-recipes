#!/bin/bash

# Hints:
# http://boost.2283326.n4.nabble.com/how-to-build-boost-with-bzip2-in-non-standard-location-td2661155.html
# http://www.gentoo.org/proj/en/base/amd64/howtos/?part=1&chap=3
# http://www.boost.org/doc/libs/1_55_0/doc/html/bbv2/reference.html

# Hints for OSX:
# http://stackoverflow.com/questions/20108407/how-do-i-compile-boost-for-os-x-64b-platforms-with-stdlibc

# Build dependencies:
# - bzip2-devel

PATCH_DIR=${RECIPE_DIR}/1.55.0_patches

mkdir -vp ${PREFIX}/bin;

if [ `uname` == Darwin ]; then
  MACOSX_VERSION_MIN=10.8
  CXXFLAGS="-mmacosx-version-min=${MACOSX_VERSION_MIN}"
  CXXFLAGS="${CXXFLAGS} -std=c++11 -stdlib=libc++"
  LINKFLAGS="-mmacosx-version-min=${MACOSX_VERSION_MIN} "
  LINKFLAGS="${LINKFLAGS} -stdlib=libc++"

  # Patches boost::atomic for LLVM 3.4 as it is used on OS X 10.9 with Xcode 5.1
  # https://github.com/Homebrew/homebrew/issues/27396
  # https://github.com/Homebrew/homebrew/pull/27436
  patch -Np2 -i ${PATCH_DIR}/6bb71fdd.diff
  patch -Np2 -i ${PATCH_DIR}/e4bde20f.diff
  # Patch boost::serialization for Clang
  # https://svn.boost.org/trac/boost/ticket/8757
  patch -Np1 -i ${PATCH_DIR}/0005-Boost.S11n-include-missing-algorithm.patch

  B2ARGS="toolset=clang"

  ./bootstrap.sh \
    --prefix="${PREFIX}/" --libdir="${PREFIX}/lib/" \
    | tee bootstrap.log 2>&1
  ./b2 \
    variant=release address-model=64 architecture=x86 \
    threading=multi link=shared ${B2ARGS} \
    cxxflags="${CXXFLAGS}" linkflags="${LINKFLAGS}" \
    install | tee b2.log 2>&1
else
  B2ARGS="toolset=gcc"

  ./bootstrap.sh \
    --prefix="${PREFIX}/" --libdir="${PREFIX}/lib/" \
    | tee bootstrap.log 2>&1
  ./b2 \
    variant=release address-model=64 architecture=x86 \
    threading=multi link=shared ${B2ARGS} \
    install | tee b2.log 2>&1
fi

#POST_LINK="${PREFIX}/bin/.boost-post-link.sh"
#cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
#chmod -v 0755 ${POST_LINK};
