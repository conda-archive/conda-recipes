#!/bin/bash

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

$R CMD INSTALL --build .

# Add more build steps here, if they are necessary.
# The build for data.table moves data.table.so to datatable.so, but doesn't
# change the install name, which confuses the conda-build post build stuff.
if [ $(uname) = "Darwin" ]; then
    install_name_tool -id datatable.so $PREFIX/lib/R/library/data.table/libs/datatable.so
fi

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
