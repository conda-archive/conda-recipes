#!/bin/bash
export R_HOME=$PREFIX/lib/R

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

# The openssl package isn't built with the @rpath logic on OS X. Instead of
# rebuilding it, we'll just use this as a workaround.
export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib:$(HOME)/lib:/usr/local/lib:/lib:/usr/lib

$R CMD INSTALL --build .

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
