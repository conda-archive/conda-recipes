# Qt5 installs .prl files with hard-coded prefixes containing \\\\ path
# separators, which conda does not know how to replace on install.
# This script searches for such paths, and replaces the path separators
# with /.

import glob
import os
import sys

LIBQT5 = os.path.join(os.environ['PREFIX'], 'Library', 'lib', 'qt5')

for filename in glob.glob(os.path.join(LIBQT5, '*.prl')):
    with open(filename, 'r') as f:
        data = f.read()
    data = data.replace('\\\\', '/')
    with open(filename, 'w') as f:
        f.write(data)
