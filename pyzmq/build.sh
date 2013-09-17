#!/bin/bash
set -e

"$PYTHON" setup.py configure --zmq "$PREFIX"

"$PYTHON" setup.py install
