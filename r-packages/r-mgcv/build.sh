#!/bin/bash

# These recursively depend on r-mgcv, since it is a recommended package, so
# install it manually

conda install --no-deps r-matrix r-nlme r-lattice

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

$R CMD INSTALL --build .

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
