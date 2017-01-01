#!/bin/bash

SYBASE=${PREFIX} \
  $PYTHON setup.py build_ext -D HAVE_FREETDS
SYBASE=${PREFIX} \
  $PYTHON setup.py install --single-version-externally-managed --record=record.txt

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
