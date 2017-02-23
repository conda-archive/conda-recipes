CHOST="arm-unknown-linux-uclibcgnueabi"
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

# If dirty is unset or the g++ binary doesn't exist yet, then run ct-ng
# TODO :: Change && to ||, this is to prevent rebuilds when I forget to add --dirty.
#if [[ -z ${DIRTY} && ! -e "${PREFIX}"/bin/arm-unknown-linux-uclibcgnueabi-g++ ]]; then
if [[ ! -e "${SRC_DIR}/gcc_built/bin/${CHOST}-gcc" ]]; then
    mv config .config
    # sed -i.bak "s|@BUILD_TOP@|${PWD}|g" .config
    # rm .config.bak
    sed -i.bak "s|CT_PARALLEL_JOBS=4|CT_PARALLEL_JOBS=${BUILD_NCPUS}|g" .config
    rm .config.bak
    # building oldconfig will ensure that the build platform specific crosstool-ng
    # configuration values (e.g. CT_CONFIGURE_has_stat_flavor_GNU) get mixed with
    # the host platform .config file.
    yes "" | ct-ng oldconfig
    ct-ng build
fi

find . -name "*activate*.sh" -exec sed -i.bak "s|@CHOST@|${CHOST}|g" "{}" \;
find . -name "*activate*.sh.bak" -exec sed rm "{}" \;

chmod u+w -R ${SRC_DIR}/gcc_built
