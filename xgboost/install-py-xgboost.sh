#!/bin/bash

pushd ${SRC_DIR}/python-package
  ${PYTHON} setup.py install --single-version-externally-managed --record=record.txt
popd
