#!/bin/sh

chmod 755 configure
./configure --prefix=$PREFIX

make
chmod 755 install-sh
make install
