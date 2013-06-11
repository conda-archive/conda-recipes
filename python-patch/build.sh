#!/bin/bash

# This will make any error fail the script
set -e

mkdir -p $PREFIX/bin/
cp $RECIPE_DIR/patch.py $PREFIX/bin/
