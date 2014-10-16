#!/bin/bash

./configure --prefix=$PREFIX --disable-debug
make
make install
