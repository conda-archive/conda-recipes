#!/bin/bash

# Force regeneration of this since we patched out
# the usage of `DBVERSION_80` in src/_mssql.pyx
rm _mssql.c
$PYTHON setup.py build_ext -I ${PREFIX}/include -L ${PREFIX}/lib
$PYTHON setup.py install --single-version-externally-managed --record=record.txt

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
