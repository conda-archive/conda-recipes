#!/bin/bash

set -e

python setup.py install --prefix=$PREFIX
ESC_PREFIX=$(python -c "print(\"${PREFIX}\".replace(\"/\", \"\\/\"))")
NEWLINE=$'\n'
sed -i.bak "s/if os.name=='nt':/os.environ[\"LD_LIBRARY_PATH\"] = \"${ESC_PREFIX}\/lib:\" + os.environ.get(\"LD_LIBRARY_PATH\", \"\")\\${NEWLINE}os.environ[\"DYLD_LIBRARY_PATH\"] = \"${ESC_PREFIX}\/lib:\" + os.environ.get(\"DYLD_LIBRARY_PATH\", \"\")\\${NEWLINE}if os.name=='nt':/g" $PREFIX/lib/python2.7/site-packages/libtiff/libtiff_ctypes.py
rm $PREFIX/lib/python2.7/site-packages/libtiff/libtiff_ctypes.py.bak
