#!/bin/sh

make OPT="${CFLAGS} -fPIC -DPIC" \
     ZLIB=no SHARED=no \
     PREFIX=${PREFIX} \
     SHAREDIR=${PREFIX}/share/hwdata \
     MANDIR=${PREFIX}/share/man \
     SBINDIR=${PREFIX}/bin \
     lib/libpci.a
cp lib/libpci.a ${PREFIX}/
make clean
make OPT="${CFLAGS}" \
     ZLIB=no \
     SHARED=yes \
     PREFIX=${PREFIX} \
     SBINDIR=${PREFIX}/bin \
     SHAREDIR=${PREFIX}/share/hwdata \
     MANDIR=${PREFIX}/share/man \
     all
make SHARED=yes \
     PREFIX=${PREFIX} \
     SBINDIR=${PREFIX}/bin \
     SHAREDIR=${PREFIX}/share/hwdata \
     MANDIR=${PREFIX}/share/man \
     install \
     install-lib
rm -rf ${PREFIX}/{sbin/update-pciids,share/{man/man8/update-pciids.8,hwdata}}
