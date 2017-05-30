#!/bin/bash

$PYTHON setup.py install

# The post-build logic chokes on these binary files, as described here:
# https://github.com/conda/conda-build/issues/411

# Since we don't needs these files on x86_64, let's just delete them.
rm ${PREFIX}/lib/python2.7/site-packages/py2app-0.9-py2.7.egg/py2app/apptemplate/prebuilt/*-fat
rm ${PREFIX}/lib/python2.7/site-packages/py2app-0.9-py2.7.egg/py2app/bundletemplate/prebuilt/*-fat
