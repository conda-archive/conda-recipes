#!/bin/bash

export CFLAGS=${CFLAGS}" -I${PREFIX}/include -L${PREFIX}/lib"
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
