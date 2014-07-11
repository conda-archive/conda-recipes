#!/bin/sh
N_CORES=`sysctl -n hw.ncpu`
make -j $N_CORES
make install

