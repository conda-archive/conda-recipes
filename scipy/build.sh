#!/bin/bash

if [ $PRO == 1 ]
then
    rm scipy/sparse/linalg/eigen/arpack/tests/test_arpack.py
    rm scipy/sparse/linalg/isolve/tests/test_iterative.py
    rm scipy/optimize/tests/test_nonlin.py

    if [ `uname` == Darwin ]; then
        export ATLAS=1
        export LDFLAGS="-headerpad_max_install_names $LDFLAGS"
    fi
fi

if [ `uname` == Darwin ]; then
    FCFLAGS=$CFLAGS
    # link statically against the fortran libraries
    cp /usr/local/lib/libgfortran*.*a .
    LDFLAGS="-undefined dynamic_lookup -bundle -Wl,-search_paths_first -L$(pwd) $LDFLAGS"
fi

$PYTHON setup.py install

if [[ (`uname` == Linux) && ($ARCH == 32) && ($PRO == 1) ]]; then
    rm $SP_DIR/scipy/linalg/tests/test_blas.py
fi
