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
#if [[ -z ${DIRTY} && ! -e "${PREFIX}"/${CHOST}-g++ ]]; then
if [[ ! -e "${SRC_DIR}/gcc_built/bin/${CHOST}-gcc" ]]; then
    if [[ ! -f .config ]]; then
      mv config .config
      sed -i.bak "s|@BUILD_TOP@|${PWD}|g" .config
      rm .config.bak
      sed -i.bak "s|CT_PARALLEL_JOBS=4|CT_PARALLEL_JOBS=${BUILD_NCPUS}|g" .config
      rm .config.bak
      if [[ $(uname) == Darwin ]]; then
        sed -i.bak "s|CT_WANTS_STATIC_LINK=y|CT_WANTS_STATIC_LINK=n|g" .config
        rm .config.bak
        sed -i.bak "s|CT_CC_GCC_STATIC_LIBSTDCXX=y|CT_CC_GCC_STATIC_LIBSTDCXX=n|g" .config
        rm .config.bak
        sed -i.bak "s|CT_STATIC_TOOLCHAIN=y|CT_STATIC_TOOLCHAIN=n|g" .config
        rm .config.bak
        sed -i.bak "s|CT_BUILD=\"x86_64-pc-linux-gnu\"|CT_BUILD=\"x86_64-apple-darwin11\"|g" .config
        rm .config.bak
        cat .config | grep CT_BUILD
      fi
      # building oldconfig will ensure that the build platform specific crosstool-ng
      # configuration values (e.g. CT_CONFIGURE_has_stat_flavor_GNU) get mixed with
      # the host platform .config file.
      yes "" | ct-ng oldconfig
    fi
    unset CFLAGS CXXFLAGS LDFLAGS
    ct-ng build
fi

find . -name "*activate*.sh" -exec sed -i.bak "s|@CHOST@|${CHOST}|g" "{}" \;
find . -name "*activate*.sh.bak" -exec sed rm "{}" \;

chmod -R u+w ${SRC_DIR}/gcc_built

# Next problem: macOS targetting uClibc ends up with broken symlinks in sysroot/usr/lib:
if [[ $(uname) == Darwin ]]; then
  pushd ${SRC_DIR}/gcc_built/${CHOST}/sysroot/usr/lib
  links=$(find . -type l | cut -c 3-)
  for link in ${links}; do
    target=$(readlink ${link} | sed 's#^/##' | sed 's#//#/#')
    rm ${link}
    ln -s ${target} ${link}
  done
  popd
fi
