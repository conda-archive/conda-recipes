#!/bin/bash

if [[ "${PY_VER%%.*}" == "2" ]]; then
    # conda-build tries to compile .pyc files in Python 2 environment, but
    # Invoke has yaml for Python3 codebase, which fails on Python2.
    # Related question on conda-build issue tracker:
    # https://github.com/conda/conda-build/pull/317#commitcomment-12926020
    # WARNING: this has to be removed when noarch_python is enabled!
    rm -rf invoke/vendor/yaml3
else
    # Python 3.5+ doesn't support syntax of old Python 2.x exceptions either.
    rm -rf invoke/vendor/yaml2
fi

$PYTHON setup.py install
