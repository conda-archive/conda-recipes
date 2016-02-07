#!/bin/bash

make all

mkdir -p $PREFIX/lib
cp ./libleveldb* $PREFIX/lib/
cp -r ./include $PREFIX/
