#!/bin/bash

make configure
./configure --prefix=$PREFIX
make all
make install
