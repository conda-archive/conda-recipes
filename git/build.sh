#!/bin/bash

make configure
./configure --prefix=$PREFIX
make
make install
