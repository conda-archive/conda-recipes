#!/bin/bash

RPM=$(basename $(find . -name "*.rpm"))
"${RECIPE_DIR}"/rpm2cpio ${RPM} | cpio -idmv
mkdir -p ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/
cp -Rf * ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/
mkdir -p ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/var/tmp
echo "dummy" > ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/var/tmp/dummy
mkdir -p ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/var/spool
rm -rf ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/var/mail
rm ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/${RPM}
rm ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/conda_build.sh
