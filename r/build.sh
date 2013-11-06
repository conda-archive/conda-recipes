#!/bin/bash

./configure --with-readline=no --prefix=$PREFIX
make
make install
