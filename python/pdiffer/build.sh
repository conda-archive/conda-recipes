#!/bin/bash

sed -i "s:.*long_description=open.*::" setup.py || exit 1;

${PYTHON} setup.py install || exit 1;

