#!/bin/bash

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

# Since `pkg-config --exists cairo --debug`
# fails because we have no xrender.pc, this
# is not such a big deal as our cairo is a
# shared library and xrender.pc is used only
# when linking statically. Still not ideal.
# perhaps a dummy xrender.pc could be added
# to the cairo package?
if [[ $(uname -s) == Linux ]]; then
  export CAIRO_LIBS="-L${PREFIX}/lib -lcairo"
  export CAIRO_CFLAGS=-I${PREFIX}/include/cairo
fi

$R CMD INSTALL --build .

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
