#!/bin/bash

# It is assumed that OS has already installed below packages:
# - doxygen

touch requirements.txt;

${PYTHON} setup.py install;

mkdir -vp ${PREFIX}/bin;

POST_LINK="${PREFIX}/bin/.breathe-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};
