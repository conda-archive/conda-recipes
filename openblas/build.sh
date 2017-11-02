# !/usr/bin/env bash

# See this workaround
# ( https://github.com/xianyi/OpenBLAS/issues/818#issuecomment-207365134 ).
CF="${CFLAGS}"
unset CFLAGS

LDFLAGS="-Wl,-rpath,${CONDA_PREFIX}/lib ${LDFLAGS}"

make \
  QUIET_MAKE=1 DYNAMIC_ARCH=1 BINARY=${ARCH} NO_LAPACK=0 \
  NO_AFFINITY=1 USE_THREAD=1 FFLAGS="${FFLAGS}" CFLAGS="${CF}" \
  PREFIX=${PREFIX} LDFLAGS="${LDFLAGS}"
make install PREFIX=$PREFIX

# As OpenBLAS, now will have all symbols that BLAS or LAPACK have,
# create libraries with the standard names that are linked back to
# OpenBLAS. This will make it easier for packages that are looking for them.
for arg in blas cblas lapack; do
    ln -fs $PREFIX/lib/pkgconfig/openblas.pc $PREFIX/lib/pkgconfig/$arg.pc
    ln -fs $PREFIX/lib/libopenblas.a $PREFIX/lib/lib$arg.a
    ln -fs $PREFIX/lib/libopenblas$SHLIB_EXT $PREFIX/lib/lib$arg$SHLIB_EXT
done
