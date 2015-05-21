#!/bin/bash

./configure --shared --prefix=$PREFIX
make
make install
