#!/bin/bash

${PYTHON} setup.py install || exit 1;

if [[ "$OSTYPE" == "darwin"* ]]; then
cp build/pyne/lib/*.dylib $PREFIX/lib
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
find . -name '*.so' | xargs chmod +x
cp build/pyne/lib/*.so $PREFIX/lib
fi

