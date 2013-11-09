#!/bin/bash
#CC=cc CXX=c++ ./configure --prefix=$PREFIX
toolset=clang ./bootstrap.sh --prefix=$PREFIX
toolset=clang ./b2 install
