#!/bin/bash

cd TPL/libsvm-3.1-custom

make lib
mkdir -p $PREFIX/lib
mv libsvm* $PREFIX/lib/

mkdir -p $SP_DIR
mv python/svm.py $SP_DIR/
mv python/svmutil.py $SP_DIR/

mkdir -p $PREFIX/include
mv svm.h ${PREFIX}/include/
