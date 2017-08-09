#!/bin/bash

pushd xar
  ./autogen.sh --noconfigure
  # Because --disable-shared happily links to shared libs
  rm -f "${PREFIX}"/lib/lib{xml2,bz2,z,lzma,iconv}*.dylib*
  ./configure --prefix=${PREFIX}     \
              --with-lzma=${PREFIX}  \
              --disable-shared 
  make
  make install
popd
