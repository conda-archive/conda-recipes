#!/bin/bash

touch requirements.txt;

#export CFLAGS="-m64 -pipe -O2 -march=x86-64"
#export CXXFLAGS="${CFLAGS}"
#export LDFLAGS="-arch x86_64"

${PYTHON} setup.py install;

mkdir -vp ${PREFIX}/bin;

#POST_LINK="${PREFIX}/bin/.pyne-post-link.sh"
#cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
#chmod -v 0755 ${POST_LINK};

#scripts/nuc_data_make

#declare -a item_list=(
#    "libpyne_data.so"
#    "libpyne_enrichment.so"
#    "libpyne_material.so"
#    "libpyne_nucname.so"
#    "libpyne_rxname.so"
#    "libpyne.so"
#)
#
#pushd ${SP_DIR}/pyne;
#for item in "${item_list[@]}"; do
#    [[ ! -e ${item} ]] && {
#        ln -s lib/${item} ${item##lib};
#    }
#done
#popd
