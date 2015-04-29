ln -s $PREFIX/lib $PREFIX/lib64

if [ "$(uname)" == "Darwin" ]; then
    export LDFLAGS="-Wl,-headerpad_max_install_names"
    export BOOT_LDFLAGS="-Wl,-headerpad_max_install_names"

    ./configure \
        --prefix=$PREFIX \
        --libdir=$PREFIX/lib \
        --with-gmp=$PREFIX \
        --with-mpfr=$PREFIX \
        --with-mpc=$PREFIX \
        --with-isl=$PREFIX \
        --with-cloog=$PREFIX \
        --with-boot-ldflags=$LDFLAGS \
        --with-stage1-ldflags=$LDFLAGS \
        --enable-checking=release \
        --disable-multilib
else
    ./configure \
        --prefix=$PREFIX \
        --libdir=$PREFIX/lib \
        --with-gmp=$PREFIX \
        --with-mpfr=$PREFIX \
        --with-mpc=$PREFIX \
        --with-isl=$PREFIX \
        --with-cloog=$PREFIX \
        --enable-checking=release \
        --disable-multilib
fi
make
make install
rm $PREFIX/lib64


# Lastly, remove the headers that gcc "fixed".
# They kill the gcc binary's portability to other systems,
#   and shouldn't be necessary on ANSI-compliant systems anyway.
# More discussion can be found here:
# https://groups.google.com/a/continuum.io/d/msg/conda/HwUazgD-hJ0/aofO0vD-MhcJ
# (We can skip this step on Mac, because the "fixed" 
#  headers on Mac seem to be forward compatible.)
if [ "$(uname)" != "Darwin" ]; then
    while read x ; do
      grep -q 'It has been auto-edited by fixincludes from' "${x}" \
               && rm -f "${x}"
    done < <(find ${PREFIX}/lib/gcc/*/*/include*/ -name '*.h')
fi
