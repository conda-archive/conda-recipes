#!/bin/bash

mkdir -vp ${PREFIX}/bin;

touch requirements.txt;

${PYTHON} setup.py install || exit 1;

