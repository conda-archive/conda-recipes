#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]
then
    SED_INPLACE=("sed" "-i" "" "-E")
    "${SED_INPLACE[@]}" "s:#ifdef WITH_NEXT_FRAMEWORK:#if 1:g" src/_macosx.m
else
    SED_INPLACE=("sed" "-i" "-r")
fi

cp setup.cfg.template setup.cfg || exit 1

"${SED_INPLACE[@]}" "s:/usr/local:$PREFIX:g" setupext.py

"$PYTHON" setup.py install

rm -rf "$SP_DIR/PySide"
rm -rf "$SP_DIR/__pycache__"
rm -rf "$PREFIX/bin/nose"*
