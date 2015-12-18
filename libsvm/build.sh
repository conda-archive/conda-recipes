#!/bin/bash

make lib
mkdir $PREFIX/lib
mv libsvm* $PREFIX/lib/
