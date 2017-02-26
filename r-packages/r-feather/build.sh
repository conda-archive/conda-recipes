#!/bin/bash

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

# conda-build sets this to 10.7 at present, and that changes
# the behaviour of clang++ such that <cstdint> is not found.
if [[ ${MACOSX_DEPLOYMENT_TARGET} == 10.7 ]]; then
  export MACOSX_DEPLOYMENT_TARGET=10.9
fi
$R CMD INSTALL --build .

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
