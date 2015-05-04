#!/bin/sh

if [ "$(uname)" != "Darwin" ]; then

    # Locate the system's C-runtime object files and link them into the gcc 
    #  build so they are automatically on the gcc search path.
    # (The location of these files varies from one system to the next.)
    C_RUNTIME_OBJ_FILES="crt0.o crt1.o crt2.o crt3.o crti.o crtn.o"
    SYSTEM_GCC=/usr/bin/gcc

    for obj_file in $C_RUNTIME_OBJ_FILES; do
	obj_file_full_path=`gcc -print-file-name=$obj_file`
	if [[ $obj_file_full_path != $obj_file ]]; then
	    ln -s $obj_file_full_path ${PREFIX}/lib/gcc/*/*/
	fi
    done
    
    # Some distros use different system include paths than the ones this gcc binary was built for.
    # We'll add these to the standard include path by providing a custom "specs file"

    # First create specs file from existing defaults
    SPECS_DIR=`echo ${PREFIX}/lib/gcc/*/*`
    SPECS_FILE=${SPECS_DIR}/specs
    gcc -dumpspecs > ${SPECS_FILE}
    
    # Now add extra include paths to the specs file, one at a time.
    # (So far we only know of one: from Ubuntu.)
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

## TEST: Here we verify that gcc can build a simple "Hello world" program for both C and C++.
##
## Note: This tests the gcc package's ability to actually function as a compiler.
##       Therefore, packages should never depend on the gcc package as a 'run' dependency, 
##       i.e. just for its packaged libraries (they should depend on 'libgcc' instead).
##       That way, if there are systems which can't use this gcc package for its
##       compiler (due to portability issues) can still use packages produced with it.

workdir=`mktemp -d` && cd $workdir

# Write test programs.
cat > hello.c <<EOF
#include <stdio.h>
int main()
{
    printf("Hello, world! I can compile C.\n");
    return 0;
}
EOF

cat > hello.cpp <<EOF
#include <iostream>
int main()
{
    std::cout << "Hello, world! I can compile C++." << std::endl;
    return 0;
}
EOF

set +e

# Compile.
(
    set -e
    gcc -o hello_c.out hello.c
    g++ -o hello_cpp.out hello.cpp
)
SUCCESS=$?
if [ $SUCCESS -ne 0 ]; then
    echo "Installation failed: gcc is not able to compile a simple 'Hello, World' program."
    rm -r $workdir
    exit 1;
fi

# Execute the compiled output.
(
    set -e
    ./hello_c.out > /dev/null
    ./hello_cpp.out > /dev/null
)
SUCCESS=$?
if [ $SUCCESS -ne 0 ]; then
    echo "Installation failed: Compiled test program did not execute cleanly."
    rm -r $workdir
    exit 1;
fi

rm -r $workdir
