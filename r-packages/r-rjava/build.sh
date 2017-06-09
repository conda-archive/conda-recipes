#!/bin/bash

unset R_JAVA_LD_LIBRARY_PATH
unset JAVA_HOME
unset LD_LIBRARY_PATH
# Because I neutered ldpaths to do nothing when $(uname) is 'Linux'
echo "!#/usr/bin/env bash" > ./uname
echo "echo faked" >> ./uname
chmod +x ./uname
PATH=$PWD:$PATH . ${PREFIX}/lib/R/etc/ldpaths

# R refuses to build packages that mark themselves as Priority: Recommended
mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION

$R CMD INSTALL --build .

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
