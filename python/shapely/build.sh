#!/bin/bash

export GEOS_DIR=$PREFIX

$PYTHON setup.py install || exit 1
