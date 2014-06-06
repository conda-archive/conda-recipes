#!/bin/bash

mkdir -vp ${PREFIX}/bin;

touch requirements.txt;

${PYTHON} setup.py submodule || exit 1;
${PYTHON} setup.py install || exit 1;
