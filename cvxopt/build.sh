#!/bin/bash

export CVXOPT_BUILD_GSL=1
export CVXOPT_BUILD_FFTW=1
export CVXOPT_BUILD_DSDP=1
export CVXOPT_BUILD_GLPK=1
export CVXOPT_GSL_LIB_DIR=${PREFIX}/lib
export CVXOPT_GSL_INC_DIR=${PREFIX}/include
export CVXOPT_FFTW_LIB_DIR=${PREFIX}/lib
export CVXOPT_FFTW_INC_DIR=${PREFIX}/include
export CVXOPT_GLPK_LIB_DIR=${PREFIX}/lib
export CVXOPT_GLPK_INC_DIR=${PREFIX}/include
export CVXOPT_DSDP_LIB_DIR=${PREFIX}/lib
export CVXOPT_DSDP_INC_DIR=${PREFIX}/include/dsdp

if [[ ${NOMKL} == 1 ]]; then
  curl -SLO http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.5.tar.gz
  tar -xf SuiteSparse-4.5.5.tar.gz
  export CVXOPT_SUITESPARSE_SRC_DIR=${PWD}/SuiteSparse
else
  export CVXOPT_BLAS_LIB=openblas
  export CVXOPT_LAPACK_LIB=openblas
  export CVXOPT_SUITESPARSE_LIB_DIR=${PREFIX}/lib
  export CVXOPT_SUITESPARSE_INC_DIR=${PREFIX}/include
fi

if [ `uname` == Linux ]
then
    export LDFLAGS="$LDFLAGS -Wl,--no-as-needed -lrt"
fi
if [ `uname` == Darwin ]; then
    export LDFLAGS="-headerpad_max_install_names $LDFLAGS"
fi

$PYTHON setup.py install
