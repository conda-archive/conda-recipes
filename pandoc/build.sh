#!/bin/bash

if [ $(uname) == Linux ]; then
  if [ "${ARCH}" == "32" ]; then
    wget -c --no-check-certificate https://copr-be.cloud.fedoraproject.org/results/petersen/pandoc-el5/epel-5-i386/00125413-pandoc/pandoc-citeproc-0.7.2-1.i386.rpm
  else
    wget -c --no-check-certificate https://copr-be.cloud.fedoraproject.org/results/petersen/pandoc-el5/epel-5-x86_64/00125413-pandoc/pandoc-citeproc-0.7.2-1.x86_64.rpm
  fi
  RPMS=$(find . -name "*.rpm")
  for RPM in ${RPMS}; do
    rpm2cpio ${RPM} | cpio -idv
  done
  mkdir -p ${PREFIX}/bin
  mv usr/bin/* ${PREFIX}/bin
  # I have not got the time to add GHC
  # to conda and must therefore do this
  for EXE in pandoc pandoc-citeproc; do
    patchelf --replace-needed libgmp.so.3 libgmp.so.10 ${PREFIX}/bin/${EXE}
    patchelf --replace-needed libffi.so.5 libffi.so.6  ${PREFIX}/bin/${EXE}
  done
fi

if [ $(uname) == Darwin ]; then
  pkgutil --expand pandoc-${PKG_VERSION}-osx.pkg pandoc
  cpio -i -I pandoc/pandoc.pkg/Payload
  mkdir -p ${PREFIX}/bin
  cp usr/local/bin/* ${PREFIX}/bin/
  for EXE in pandoc pandoc-citeproc; do
    # Unfortunately neither -headerpad nor -headerpad_max_install_names were used when building this.
    # install_name_tool -change /usr/lib/libz.1.dylib     $PREFIX/lib/libz.1.dylib     ${PREFIX}/bin/${EXE}
    # install_name_tool -change /usr/lib/libiconv.2.dylib $PREFIX/lib/libiconv.2.dylib ${PREFIX}/bin/${EXE}
    install_name_tool -change /usr/lib/libz.1.dylib     @loader_path/../lib/libz.1.dylib     ${PREFIX}/bin/${EXE}
    # install_name_tool -change /usr/lib/libiconv.2.dylib @loader_path/../lib/libiconv.2.dylib ${PREFIX}/bin/${EXE}
  done
fi
