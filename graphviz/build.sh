#!/bin/sh
# see http://conda.pydata.org/docs/build.html for hacking instructions.

export CFLAGS="-Wall -g -m${ARCH} -pipe -O2 -fPIC"
export CXXLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

./autogen.sh

if [ `uname` == Darwin ]; then
./configure --prefix=$PREFIX --with-quartz
else
./configure --prefix=$PREFIX
fi

make -j${CPU_COUNT}

if [[ $(uname) == Darwin ]]; then
    # For some reason, libltdl.7.dylib can't be found without setting the rpath,
    # and it even prevents 'make install' from working.
    install_name_tool -add_rpath ${PREFIX}/lib cmd/dot/.libs/dot
fi 

make install

# vim: set ai et nu:

# Configure plugins
# (Writes ${PREFIX}/lib/graphviz/config with available plugin information.)
$PREFIX/bin/dot -c
