#!/bin/bash

patch -p0 <<EOF
--- setup.cfg~  2011-05-29 22:31:18.000000000 -0500
+++ setup.cfg   2012-07-10 20:33:50.000000000 -0500
@@ -4,10 +4,10 @@
 [build_ext]
 
 # List of directories to search for 'yaml.h' (separated by ':').
-#include_dirs=/usr/local/include:../../include
+include_dirs=$PREFIX/include
 
 # List of directories to search for 'libyaml.a' (separated by ':').
-#library_dirs=/usr/local/lib:../../lib
+library_dirs=$PREFIX/lib
 
 # An alternative compiler to build the extention.
 #compiler=mingw32
EOF

$PYTHON setup.py install
