#!/bin/bash

./configure --prefix=$PREFIX || exit 1
make || exit 1
make install || exit 1
