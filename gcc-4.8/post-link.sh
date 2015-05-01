#!/bin/sh

if [ "$(uname)" != "Darwin" ]; then

    # Locate the system's C-runtime object files and link them into the gcc 
    #  build so they are automatically on the gcc search path.
    # (The location of these files varies from one system to the next.)
    C_RUNTIME_OBJ_FILES="crt1.o crti.o crtn.o"
    SYSTEM_GCC=/usr/bin/gcc
    
    DUMMY_PROGRAM="int main(){return 0;}"
    GCC_CMDS=`echo "$DUMMY_PROGRAM" | $SYSTEM_GCC -v -xc - 2>&1`
    COLLECT2_FILES=`echo "$GCC_CMDS" | grep collect2`
    
    for path in $COLLECT2_FILES; do
        for obj_file in $C_RUNTIME_OBJ_FILES; do
            if echo $path | grep -qs $obj_file; then
                echo "Linking $path into gcc build"
                ln -s $path ${PREFIX}/lib/gcc/*/*/
            fi
        done
    done
fi
