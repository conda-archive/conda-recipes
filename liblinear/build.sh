#!/bin/bash

make lib
mkdir $PREFIX/lib
mv liblinear* $PREFIX/lib/
