#!/bin/bash

${PYTHON} setup.py install || exit 1;

#POST_LINK=${PREFIX}/bin/.continuumweb-post-link.sh
#cp ${RECIPE_DIR}/post-link.sh ${POST_LINK}
#chmod +x ${POST_LINK}
