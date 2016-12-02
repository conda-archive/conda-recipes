#!/bin/bash

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX
cmake --build . --config Release --target all
cmake --build . --config Release --target install
