#!/bin/sh

cmake . -DCMAKE_INSTALL_PREFIX=$PREFIX -DDEFAULT_CHARSET=utf-8
make
make install
