#!/bin/bash

make

BIN=$PREFIX/bin
mkdir $BIN
cp filebin $BIN
