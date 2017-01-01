#!/bin/bash

export CPPFLAGS="-I${PREFIX}/include -DDEBUG -O0 -g"
echo $CPPFLAGS
DISTUTILS_DEBUG=1 python setup.py install
