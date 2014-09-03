#!/bin/bash

ncpus=1
if test -x /usr/bin/getconf; then
    ncpus=$(/usr/bin/getconf _NPROCESSORS_ONLN)
fi

# tested on OSX 10.8.5

make -j$ncpus
# filter libtbb.dylib ( or .so ), libtbbmalloc.dylib ( or .so )
cp `find . -name "*lib*" | grep tbb | grep release` $PREFIX/lib

# copy the include files
cp -r ./include/tbb $PREFIX/include/tbb

