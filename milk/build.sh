#!/bin/bash

./get-eigen.sh
$PYTHON setup.py install

# Add more build steps here, if they are necessary.

# See
# https://github.com/ContinuumIO/conda/blob/master/docs/source/build.rst
# for a list of environment variables that are set during the build process.
