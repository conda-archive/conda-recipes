#!/bin/bash

cp "${RECIPE_DIR}"/setup_unix.py "${SRC_DIR}"/setup.py

python setup.py install
