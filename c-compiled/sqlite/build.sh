#/bin/sh

# Compile the interpreter
gcc -O2 shell.c sqlite3.c -I. -I$PREFIX/include \
    -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS5 \
    -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_RTREE \
    -DSQLITE_ENABLE_EXPLAIN_COMMENTS \
    -ldl -lc -lm -lpthread -o sqlite3

# make the shared library
gcc -O2 -c -fPIC sqlite3.c -I. -I$PREFIX/include \
    -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS5 \
    -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_RTREE \
    -DSQLITE_ENABLE_EXPLAIN_COMMENTS \
    -o sqlite3.o
gcc -shared sqlite3.o -ldl -L$PREFIX/lib -lpthread -lm -lc -fPIC -o libsqlite3.so

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/lib
mkdir -p ${PREFIX}/include

cp sqlite3 ${PREFIX}/bin/
cp libsqlite3.so ${PREFIX}/lib/
cp sqlite3.h ${PREFIX}/include/
