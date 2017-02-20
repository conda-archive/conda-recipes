echo $(pwd)
mkdir -p .build/src
mkdir -p .build/tarballs

BUILD_NCPUS=4
if [ "$(uname)" == "Linux" ]; then
  BUILD_NCPUS=$(grep -c ^processor /proc/cpuinfo)
elif [ "$(uname)" == "Darwin" ]; then
  BUILD_NCPUS=$(sysctl -n hw.ncpu)
elif [ "$OSTYPE" == "msys" ]; then
  BUILD_NCPUS=${NUMBER_OF_PROCESSORS}
fi

cp ${RECIPE_DIR}/config .config

sed -i.bak "s|@PREFIX@|${PREFIX}|g" .config
rm .config.bak
sed -i.bak "s|@BUILD_TOP@|${PWD}|g" .config
rm .config.bak
sed -i.bak "s|CT_PARALLEL_JOBS=4|CT_PARALLEL_JOBS=${BUILD_NCPUS}|g" .config
rm .config.bak

# If dirty is unset or the g++ binary doesn't exist yet, then run ct-ng
# TODO :: Change && to ||, this is to prevent rebuilds when I forget to add --dirty.
#if [[ -z ${DIRTY} && ! -e "${PREFIX}"/bin/arm-unknown-linux-uclibcgnueabi-g++ ]]; then
if [[ ! -e "${PREFIX}"/bin/arm-unknown-linux-uclibcgnueabi-g++ ]]; then
   ct-ng build
fi

# increase stack size to prevent test failures
# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31827
# ulimit -s 32768

# pushd .build/x86_64-sarc-linux-gnu/build/build-cc-gcc-final
# make -k check || true
# popd

# .build/src/gcc-${PKG_VERSION}/contrib/test_summary

chmod u+w -R ${PREFIX}
