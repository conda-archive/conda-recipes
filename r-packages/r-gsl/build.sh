#!/bin/bash

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

export CFLAGS="$(gsl-config --cflags)"
export LDFLAGS="$(gsl-config --libs)"

# For whatever reason, it can't link to gsl correctly without this on OS X.
export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib

$R CMD INSTALL --build .

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
