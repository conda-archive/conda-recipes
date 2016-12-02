#!/bin/bash

# This appears in the "About" dialog, but qmake is not good and I cannot
# find any way to prevent it getting mangled (-DAnaconda -DBuild ...)
# echo DEFINES += IDE_VERSION_DESCRIPTION=\\\"Anaconda Build ${PKG_BUILDNUM}\\\" >> qtcreator.pro
qmake -r qtcreator.pro QTC_PREFIX=/ QBS_INSTALL_PREFIX=/
# Work-around a race condition on OS X? "make[2]: write error"
make || make || make
make install INSTALL_ROOT=${PREFIX}
