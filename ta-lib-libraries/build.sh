#!/bin/bash

#===================== REMOVE THE OUTSIDE PATH VARIABLES
echo "RESET PATH to Conda ENV"
export PATH=$PREFIX/bin:$PREFIX/include:$PREFIX/lib

#===================== ADD Main System Path
export PATH=$PATH:/usr/bin:/bin
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

echo "=====================================
CONDA_BUILD:        $CONDA_BUILD
ARCH:               $ARCH
PREFIX:             $PREFIX
PYTHON:             $PYTHON
PY3K:               $PY3K
STDLIB_DIR:         $STDLIB_DIR
SP_DIR:             $SP_DIR
SYS_PREFIX:         $SYS_PREFIX
SYS_PYTHON:         $SYS_PYTHON
PY_VER:             $PY_VER
SRC_DIR:            $SRC_DIR

PATH:               $PATH
HOME:               $HOME
LANG:               $LANG
PKG_CONFIG_PATH:    $PKG_CONFIG_PATH

LD_RUN_PATH:        $LD_RUN_PATH

PKG_NAME:           $PKG_NAME
PKG_VERSION:        $PKG_VERSION
RECIPE_DIR:         $RECIPE_DIR

-------------------------------------
PYTHONPATH:         $PYTHONPATH 

PWD:                $PWD

====================================="


./configure --prefix=$PREFIX
make
make check
make install
