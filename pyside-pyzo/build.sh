#!/bin/bash

#export PATH=$PATH:$PREFIX/bin

# Go into dir that contains
# shiboken, pyside and pyside tools
cd sources

# ------------------------- PATCHELF
cd patchelf
g++ patchelf.cc -o patchelf
cp patchelf $PREFIX/bin/patchelf


# ------------------------- SHIBOKEN
cd ..
cd shiboken
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


# ------------------------- PYSIDE
cd ..
cd ..
cd pyside
mkdir build
cd build

# For some reason, QtCore is not found, 
# so add the lib dir to library search path
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX/lib

cmake \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DCMAKE_MODULE_PATH=$PREFIX/lib \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    -DShiboken_DIR=$PREFIX \
    -DQT_RCC_EXECUTABLE=$PREFIX/bin/rcc \
    -DQT_UIC_EXECUTABLE=$PREFIX/bin/uic \
    -DQT_MOC_EXECUTABLE=$PREFIX/bin/moc \
    ..
make
make install



# ------------------------- PYSIDE-TOOLS
cd ..
cd ..
cd pyside-tools
mkdir build
cd build

cmake \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_RPATH=$LD_RUN_PATH \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DCMAKE_MODULE_PATH=$PREFIX/lib \
    -DQT_QMAKE_EXECUTABLE=$PREFIX/bin/qmake \
    -DLIB_INSTALL_DIR=$PREFIX/lib \
    -DShiboken_DIR=$PREFIX \
    -DQT_RCC_EXECUTABLE=$PREFIX/bin/rcc \
    -DQT_UIC_EXECUTABLE=$PREFIX/bin/uic \
    -DQT_MOC_EXECUTABLE=$PREFIX/bin/moc \
    ..
make
make install

# ----------------- FIXING RPATH
# Is conda not supposed to do this for us?
# Without the patch below, PySide does not work

$PYTHON -c '
import sys, os, subprocess
libdir = sys.prefix + "/lib" 
pysidedir = sys.prefix + "/lib/python3.3/site-packages/PySide"
patchelf = sys.prefix + "/bin/patchelf"

def patch(dirname, rpath, *patterns):
    for fname in os.listdir(dirname):
        filename = os.path.join(dirname, fname)
        filename = os.path.abspath(filename)
        fname = os.path.basename(filename)
        do = False
        for pattern in patterns:
    	    do = do or (pattern in fname)
        if not do or ".so" not in fname:
            continue
        cmd1 = [patchelf, "--print-rpath", filename]
        cmd2 = [patchelf, "--set-rpath", rpath, filename]
        print("patching RPATH in %s" % fname)
        old_rpath = subprocess.check_output(cmd1).decode("utf-8").strip()
        subprocess.check_call(cmd2)
        print("  RPATH \"%s\"  ->  \"%s\"" % (old_rpath, rpath))

patch(libdir, "$ORIGIN/.", "shiboken", "pyside")
patch(pysidedir, "$ORIGIN/.:$ORIGIN/../../..", "Qt")
patch(os.path.dirname(pysidedir), "$ORIGIN/.:$ORIGIN/../..", "shiboken")
'

