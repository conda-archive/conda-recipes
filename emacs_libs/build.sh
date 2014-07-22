#!/bin/bash
#ls /usr/lib64/ | grep gtk | xargs -i{} cp -r  /usr/lib64/{} $PREFIX/lib
echo $PREFIX
ls $PREFIX
mkdir $PREFIX/lib
cp -r  /usr/lib64/* $PREFIX/lib/
#find /usr/lib64/ -maxdepth 1 -type f | xargs -i{} cp -r {} $PREFIX/lib
ls $PREFIX/lib

