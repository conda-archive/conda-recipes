#!/bin/bash

touch requirements.txt;

export RHOME="${PREFIX}/lib64/R"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${RHOME}/lib:${SRC_DIR}/src"

${PYTHON} setup.py install;

mkdir -vp ${PREFIX}/bin;

POST_LINK="${PREFIX}/bin/.rpy-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};

pushd ${PREFIX}/lib
[[ -f libR.so ]] && rm -v libR.so
ln -vs ../lib64/R/lib/libR.so .
[[ -f libRlapack.so ]] && rm -v libRlapack.so
ln -vs ../lib64/R/lib/libRlapack.so .
[[ -f libRblas.so ]] && rm -v libRblas.so
ln -vs ../lib64/R/lib/libRblas.so .
popd
