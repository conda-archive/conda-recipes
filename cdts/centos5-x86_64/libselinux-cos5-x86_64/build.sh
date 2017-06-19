#!/bin/bash

RPM=$(basename $(find . -name "*.rpm"))
"${RECIPE_DIR}"/rpm2cpio ${RPM} | cpio -idmv
mkdir -p ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/
cp -Rf * ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/
rm ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/${RPM}
rm ${PREFIX}/x86_64-conda_cos5-linux-gnu/sysroot/conda_build.sh
