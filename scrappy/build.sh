#!/bin/bash

touch requirements.txt

${PYTHON} setup.py install

POST_LINK=${PREFIX}/bin/.scrappy-post-link.sh
cp ${RECIPE_DIR}/post-link.sh ${POST_LINK}
chmod +x ${POST_LINK}
