#!/bin/bash


unset LDFLAGS

$PYTHON setup.py install


# Make sure the linked gfortran libraries are searched for on the RPATH.
if [[ `uname` == 'Darwin' ]]; then
    GFORTRAN_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libgfortran.3.dylib)\"))")
    GCC_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libgcc_s.1.dylib)\"))")
    QUADMATH_LIB=$(python -c "from os.path import realpath; print(realpath(\"$(gfortran -print-file-name=libquadmath.0.dylib)\"))")

    for EACH_FILE in `find ${SP_DIR}/numpy -name "*.so"`;
    do
        install_name_tool -change $GFORTRAN_LIB @rpath/libgfortran.3.dylib $EACH_FILE
        install_name_tool -change $GCC_LIB @rpath/libgcc_s.1.dylib $EACH_FILE
        install_name_tool -change $QUADMATH_LIB @rpath/libquadmath.0.dylib $EACH_FILE
    done
fi
