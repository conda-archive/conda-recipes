#!/bin/bash

set -e

if [[ `uname` == 'Darwin' ]]; then
    DYLIB_EXT=dylib
else
    DYLIB_EXT=so
fi


python setup.py install --prefix=$PREFIX
ESC_PREFIX=$(python -c "print(\"${PREFIX}\".replace(\"/\", \"\\/\"))")
NEWLINE=$'\n'
sed -i.bak "s/if os.name=='nt':/os.environ[\"LD_LIBRARY_PATH\"] = \"${ESC_PREFIX}\/lib:\" + os.environ.get(\"LD_LIBRARY_PATH\", \"\")\\${NEWLINE}os.environ[\"DYLD_LIBRARY_PATH\"] = \"${ESC_PREFIX}\/lib:\" + os.environ.get(\"DYLD_LIBRARY_PATH\", \"\")\\${NEWLINE}if os.name=='nt':/g" $PREFIX/lib/python2.7/site-packages/libtiff/libtiff_ctypes.py
rm $PREFIX/lib/python2.7/site-packages/libtiff/libtiff_ctypes.py.bak

ln -s $PREFIX/lib/libtiff.$DYLIB_EXT $SP_DIR/libtiff/libtiff.$DYLIB_EXT
