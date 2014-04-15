#!/bin/bash

$PYTHON setup.py install

mkdir $EXAMPLES
mv examples $EXAMPLES/bokeh
