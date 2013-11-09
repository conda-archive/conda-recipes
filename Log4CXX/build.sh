#!/bin/bash
CC=cc CXX=c++ ./configure --prefix=$PREFIX
make
make install
