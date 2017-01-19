#!/bin/bash

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib
$R CMD INSTALL --build --configure-args="--with-nlopt-cflags=-I${PREFIX}/include --with-nlopt-libs=\"-L${PREFIX}/lib -lnlopt_cxx\"" .

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
