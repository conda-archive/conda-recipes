#!/bin/bash

export PNG_DIR=$PREFIX
export FTYPE_DIR=$PREFIX
export HDF5_DIR=$PREFIX

$PYTHON setup.py install
