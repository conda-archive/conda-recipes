#!/bin/bash

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

# This package makes a standalone binary and needs to find libraries essential to R.
# It is likely that src/Makevars.in should use $(MAIN_LINK) from lib/R/etc/Makeconf
# for this instead of having to pass it in via the PKG_LIBS environment variable.
if [[ $(uname) == Darwin ]]; then
  PKG_LIBS="-L${PREFIX}/lib" $R CMD INSTALL --build .
else
  # .. on Linux the situation is even worse:
  LD_LIBRARY_PATH=${PREFIX}/lib/R/lib:${PREFIX}/lib \
  PKG_LIBS="-L${PREFIX}/lib -L${PREFIX}/lib/R/lib -lR -lRblas" \
    $R CMD INSTALL --build .
fi

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
