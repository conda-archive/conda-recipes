#!/bin/bash

set -e

./configure --with-nrnpython=$PYTHON --with-iv --prefix=${PREFIX}
make
make install
cd ${SRC_DIR}/src/nrnpython
$PYTHON setup.py install
