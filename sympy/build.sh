#!/bin/bash

$PYTHON setup.py install

rm -rf $PREFIX/share

if [ $PY3K == 0 ]; then
    cd $SP_DIR
    rm sympy/mpmath/tests/torture.py
    rm sympy/mpmath/tests/extratest_gamma.py
    rm sympy/mpmath/libmp/exec_py3.py
fi
