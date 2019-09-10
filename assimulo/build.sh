#!/bin/sh

# Build dependencies:
# - blas-devel

if [[ ${ARCH} == '64' ]]; then
    declare -r BLAS_LIB_PATH='/usr/lib64'
else
    declare -r BLAS_LIB_PATH='/usr/lib'
fi

${PYTHON} setup.py install \
    --lapack-home=${PREFIX}/lib \
    --blas-home=${BLAS_LIB_PATH} \
    --sundials-home=${PREFIX} || exit 1;
