#!/bin/bash

# conda-build tries to compile .pyc files in Python 2 environment, but Invoke
# has yaml for Python3 codebase, which fails on Python2.
# Related question on conda-build issue tracker:
# https://github.com/conda/conda-build/pull/317#commitcomment-12926020
# WARNING: this has to be removed when noarch_python is enabled!
if [[ "${PY_VER%%.*}" == "2" ]]; then
    rm -rf invoke/vendor/yaml3
fi

$PYTHON setup.py install
