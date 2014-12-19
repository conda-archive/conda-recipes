#!/bin/bash
unset LDFLAGS
${PYTHON} setup.py install || exit 1;

