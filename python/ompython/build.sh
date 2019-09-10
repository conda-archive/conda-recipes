#!/bin/bash

mkdir -vp ${PREFIX}/bin;

${PYTHON} setup.py install || exit 1;

