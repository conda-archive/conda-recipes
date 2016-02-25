#!/bin/bash

# install using pip from the whl file provided by Google

if [ `uname` == Darwin ]; then
    if [ "$PY_VER" == "2.7" ]; then
        pip install https://storage.googleapis.com/tensorflow/mac/tensorflow-0.6.0-py2-none-any.whl
    else
        pip install https://storage.googleapis.com/tensorflow/mac/tensorflow-0.6.0-py3-none-any.whl
    fi
fi

if [ `uname` == Linux ]; then
    if [ "$PY_VER" == "2.7" ]; then
        pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.6.0-cp27-none-linux_x86_64.whl
    else
        pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.6.0-cp34-none-linux_x86_64.whl
    fi
fi
