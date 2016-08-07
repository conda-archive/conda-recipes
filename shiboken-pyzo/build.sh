#!/bin/bash

#export PATH=$PATH:$PREFIX/bin

mkdir build
cd build

# Patch MakeLists.txt to make it use Python3
$PYTHON -c '
print("Patching CMakeLists.txt ...")
lines = []
with open("../CMakeLists.txt", "rt") as file:
    for line in file.readlines():
        if "USE_PYTHON3" in line:
            line = line.replace("FALSE", "TRUE")
            print("Patched a line")
        lines.append(line.rstrip())
open("../CMakeLists.txt", "wt").write("\n".join(lines))
print("Done patching CMakeLists.txt ...")
'

# This command is going to fail, but it will create a config
# which we can patch and then retry
set +e
cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DQT_RCC_EXECUTABLE=$PREFIX/bin/rcc \
    -DQT_UIC_EXECUTABLE=$PREFIX/bin/uic \
    -DQT_MOC_EXECUTABLE=$PREFIX/bin/moc \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    ..
set -e

# Patch CMakeCache.txt to correct paths
$PYTHON -c '
import sys, os, sysconfig
incl_dir = sysconfig.get_path("include")
lib_dir = sys.prefix + "/lib/libpython3.3m.so"
if not os.path.isfile(lib_dir):
  lib_dir = lib_dir.replace(".so",".dylib")
print("Patching build/CMakeCache.txt ...")
lines = []
with open("CMakeCache.txt", "rt") as file:
    for line in file.readlines():
        if "PYTHON3_INCLUDE_DIR:PATH" in line:
            line = line.replace("PYTHON3_INCLUDE_DIR-NOTFOUND", incl_dir)
            print("Patched a line")
        if "PYTHON3_LIBRARY:FILEPATH" in line:
            line = line.replace("PYTHON3_LIBRARY-NOTFOUND", lib_dir)
            print("Patched a line")
        lines.append(line.rstrip())
open("CMakeCache.txt", "wt").write("\n".join(lines))
print("Done patching build/CMakeCache.txt ...")
'

cmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DQT_RCC_EXECUTABLE=$PREFIX/bin/rcc \
    -DQT_UIC_EXECUTABLE=$PREFIX/bin/uic \
    -DQT_MOC_EXECUTABLE=$PREFIX/bin/moc \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    ..

make VERBOSE=2
make install

