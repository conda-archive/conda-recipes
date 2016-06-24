#!/bin/bash
if [[ -z "$GDAL_DATA" ]]; then
  export GDAL_DATA=$(gdal-config --datadir)
  export _CONDA_SET_GDAL_DATA=1
fi
