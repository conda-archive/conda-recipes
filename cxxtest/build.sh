#!/bin/bash

MYBINDIR="${PREFIX}/bin"
MYSUFFIXDIR="lib/${PKG_NAME}-${PKG_VERSION}"
MYTARGETDIR="${PREFIX}/${MYSUFFIXDIR}"

mkdir -p "${MYBINDIR}"
mkdir -p "${MYTARGETDIR}"
cp -r ./ "${MYTARGETDIR}/"
ln -s "../${MYSUFFIXDIR}/bin/cxxtestgen" "${MYBINDIR}/"
