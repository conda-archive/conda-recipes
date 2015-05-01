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

    # Some distros use different system include paths than the ones this gcc binary was built for.
    # We'll add these to the standard include path by providing a custom "specs file"

    # First create specs file from existing defaults
    SPECS_DIR=`echo ${PREFIX}/lib/gcc/*/*`
    SPECS_FILE=${SPECS_DIR}/specs
    gcc -dumpspecs > ${SPECS_FILE}
    
    # Now add extra include paths to the specs file, one at a time.
    # (So far we only know of one (from Ubuntu).)
    # TODO: Conceivably, we could extract these paths from the $GCC_CMDS output we obtained above,
    #       but hard-coding these paths is easier for now.
    EXTRA_SYSTEM_INCLUDE_DIRS="/usr/include/x86_64-linux-gnu"
    
    for INCDIR in ${EXTRA_SYSTEM_INCLUDE_DIRS}; do
        # The following sed command will replace these two lines:
        # *cpp:
        # ... yada yada ...
        #
        # With these two lines:
        # *cpp:
        # ... yada yada ... -I${INCDIR}
        sed -i ':a;N;$!ba;s|\(*cpp:\n[^\n]*\)|\1 -I'${INCDIR}'|g' ${SPECS_FILE}
    done
fi
