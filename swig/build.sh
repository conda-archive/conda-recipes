#!/bin/bash

./configure --prefix=$PREFIX
make
make -k check
make install
