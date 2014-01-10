#!/bin/bash

${PYTHON} setup.py install || exit 1;

find . -name '*.so' | xargs chmod +x
cp build/cpp/*.so ${PREFIX}/lib
