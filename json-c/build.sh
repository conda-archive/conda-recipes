#!/bin/sh

chmod 755 configure
./configure --prefix=$PREFIX

make
make install
