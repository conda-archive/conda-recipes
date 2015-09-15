#!/bin/bash

set -e

./configure --with-nrnpython=$PYTHON --with-iv=${PREFIX} --prefix=${PREFIX}
make
make install
cd ${SRC_DIR}/src/nrnpython
$PYTHON setup.py install --prefix=${PREFIX}
