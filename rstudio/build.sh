# Changing to not using an .app bundle is a bit tricky. I need to use
# Xcode.
_XCODE_BUILD=0

export RSTUDIO_VERSION_MAJOR=$(echo ${PKG_VERSION} | cut -d. -f1)
export RSTUDIO_VERSION_MINOR=$(echo ${PKG_VERSION} | cut -d. -f2)
export RSTUDIO_VERSION_PATCH=$(echo ${PKG_VERSION} | cut -d. -f3)

pushd dependencies/common
  ./install-gwt
  ./install-dictionaries
  ./install-mathjax
# ./install-boost
# ./install-pandoc
  ./install-libclang
  ./install-packages
popd

mkdir build
cd build

if ! which javac; then
  echo "Fatal: Please install javac with your system package manager"
  exit 1
fi

if ! which ant; then
  echo "Fatal: Please install ant with your system package manager"
  exit 1
fi

# Note, you can select a different default R interpreter launching
# RStudio by:
# export RSTUDIO_WHICH_R=${CONDA_PREFIX}/bin/R

# You can use this so that -Wl,-rpath-link gets used during linking
# executables. Without it, -Wl,-rpath is used anyway (and also) and
# either works fine from the perspective of ld finding transitively
# linked shared libraries:
# -DCMAKE_PLATFORM_RUNTIME_PATH=${PREFIX}/lib

export BOOST_ROOT=${PREFIX}
_VERBOSE="VERBOSE=1"

declare -a _CMAKE_EXTRA_CONFIG
if [[ $(uname) == Darwin ]]; then
  if [[ ${_XCODE_BUILD} == 1 ]]; then
    _CMAKE_EXTRA_CONFIG+=(-G'Xcode')
    _CMAKE_EXTRA_CONFIG+=(-DCMAKE_OSX_ARCHITECTURES=x86_64)
    _VERBOSE=""
  fi
  unset MACOSX_DEPLOYMENT_TARGET
  export MACOSX_DEPLOYMENT_TARGET
else
  _CMAKE_EXTRA_CONFIG+=(-DQT_QMAKE_EXECUTABLE=${PREFIX}/bin/qmake)
fi

#      -Wdev --debug-output --trace                \

cmake                                   \
      -DCMAKE_INSTALL_PREFIX=${PREFIX}  \
      -DBOOST_ROOT=${PREFIX}            \
      -DRSTUDIO_TARGET=Desktop          \
      -DCMAKE_BUILD_TYPE=Release        \
      -DLIBR_HOME=${PREFIX}/lib/R       \
      -DUSE_MACOS_R_FRAMEWORK=FALSE     \
      "${_CMAKE_EXTRA_CONFIG[@]}"       \
      ..

# "cmake --build" might be fine on all OSes/generators (though it does
# seem to be building the Debug variant on Xcode), so for now check _XCODE_BUILD
if [[ ${_XCODE_BUILD} == 1 ]]; then
  cmake --build . --target install -- ${_VERBOSE}
else
  make install ${VERBOSE}
fi

if [[ $(uname) == Darwin ]]; then
  cp -rf "${RECIPE_DIR}"/app/RStudio.app ${PREFIX}/rstudioapp
  cp "${RECIPE_DIR}"/osx-post.sh ${PREFIX}/bin/.rstudio-post-link.sh
  cp "${RECIPE_DIR}"/osx-pre.sh ${PREFIX}/bin/.rstudio-pre-unlink.sh
elif [[ $(uname) == Linux ]]; then
  echo "It would be nice to add a .desktop file here, but it would"
  echo "be even nicer if menuinst handled both that and App bundles."
fi
