#!/bin/bash

export QML_IMPORT_PATH=$PREFIX/imports
export FONTCONFIG_PATH=$PREFIX/etc/fonts

$PREFIX/tests/qt4/tst_hybridPixmap/hybridPixmap
$PREFIX/tests/qt4/tst_qdeclarativewebview/tst_qdeclarativewebview
$PREFIX/tests/qt4/tst_qgraphicswebview/tst_qgraphicswebview
$PREFIX/tests/qt4/tst_qwebelement/tst_qwebelement
$PREFIX/tests/qt4/tst_qwebframe/tst_qwebframe
$PREFIX/tests/qt4/tst_qwebhistory/tst_qwebhistory
$PREFIX/tests/qt4/tst_qwebhistoryinterface/tst_qwebhistoryinterface
$PREFIX/tests/qt4/tst_qwebinspector/tst_qwebinspector
$PREFIX/tests/qt4/tst_qwebview/tst_qwebview

# Skip these two tests because they don't finish
# on Mac, although they pass
# $PREFIX/tests/qt4/tst_loading/tst_loading
# $PREFIX/tests/qt4/tst_painting/tst_painting

# Next one is commented out due to 3 buggy tests
# See https://bugs.webkit.org/show_bug.cgi?id=29867
# $PREFIX/tests/qt4/tst_qwebpage/tst_qwebpage
