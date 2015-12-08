#!/bin/bash

cd TPL/libsvm-3.1-custom

make lib
mkdir $PREFIX/lib
mv libsvm* $PREFIX/lib/
