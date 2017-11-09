#!/bin/bash

sed -i 's|-llapack||g' make.include
sed -i "s|-lblas|-L${PREFIX}/lib -lmkl_rt|g" make.include
sed -i 's|-lg2c||g' make.include
make DSDPROOT="${PWD}" DSDPCFLAGS="-fPIC" dsdpapi

install -d ${PREFIX}/{lib,include/dsdp}
install -Dm755 bin/dsdp5 ${PREFIX}/bin/dsdp5
install -Dm644 lib/* ${PREFIX}/lib/
install -Dm644 include/*.h ${PREFIX}/include/dsdp/
install -Dm644 dsdp-license ${PREFIX}/share/licenses/$pkgname/dsdp-license
