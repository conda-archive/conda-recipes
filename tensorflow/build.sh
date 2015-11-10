#!/bin/bash

# install using pip from the whl file provided by Google

if [ `uname` == Darwin ]; then
    pip install https://storage.googleapis.com/tensorflow/mac/tensorflow-0.5.0-py2-none-any.whl
fi

if [[ (`uname` == Linux) ]]; then
    pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.5.0-cp27-none-linux_x86_64.whl
fi
