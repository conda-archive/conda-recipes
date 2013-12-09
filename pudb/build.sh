#!/bin/bash

touch requirements.txt;

mkdir -vp ${PREFIX}/bin;

${PYTHON} setup.py install || exit 1;

POST_LINK="${PREFIX}/bin/.pudb-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};

