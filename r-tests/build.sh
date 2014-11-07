
./configure --with-x                        \
            --with-pic                      \
            --prefix=$PREFIX                \
            --enable-shared                 \
            --enable-R-shlib                \
            --enable-BLAS-shlib             \
            --disable-R-profiling           \
            --disable-prebuilt-html         \
            --disable-memory-profiling      \
            --with-tk-config=$TK_CONFIG     \
            --with-tcl-config=$TCL_CONFIG

make install-tests
