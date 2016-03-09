#!/bin/bash

$PYTHON setup.py install

#I guess conda-build does not export EXAMPLES
#mkdir $EXAMPLES
#mv examples $EXAMPLES/bokeh
