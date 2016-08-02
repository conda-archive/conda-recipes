:: This appears in the "About" dialog, but qmake is not good and I cannot
:: find any way to prevent it getting mangled (-DAnaconda -DBuild ...)
:: echo DEFINES += IDE_VERSION_DESCRIPTION=\"Anaconda Build %PKG_BUILDNUM%\" >> qtcreator.pri
qmake -r qtcreator.pro CONFIG+=release QTC_PREFIX=/Library QBS_INSTALL_PREFIX=/Library
jom
jom install INSTALL_ROOT=%PREFIX%
