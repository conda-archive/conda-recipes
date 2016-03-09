#!/bin/bash

touch requirements.txt;

${PYTHON} setup.py install || exit 1;

mkdir -vp ${PREFIX}/bin;

#POST_LINK="${PREFIX}/bin/.pyopengl-post-link.sh"
#cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
#chmod -v 0755 ${POST_LINK};
