#!/bin/bash

if [[ $(uname) == Linux ]]; then
  ln -s ${PREFIX}/lib/libgfortran.so.4.0.0 ${PREFIX}/lib/libgfortran.so.3
  ln -s ${PREFIX}/lib/libgfortran.so.4.0.0 ${PREFIX}/lib/libgfortran.so.3.0
  ln -s ${PREFIX}/lib/libstdc++.so.6.0.23 ${PREFIX}/lib/libstdc++.so.6.0.21
fi
