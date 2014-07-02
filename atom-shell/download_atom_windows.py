import os
import sys
import zipfile

try:
    import urllib2
except ImportError:
    import urllib.request as urllib2

ATOM_URL = 'https://github.com/atom/atom-shell/releases/download/v0.13.3/atom-shell-v0.13.3-win32-ia32.zip'

if __name__ == '__main__':
    atom = urllib2.urlopen(ATOM_URL)

    with open(r'atom-shell.zip', 'wb') as f:
        f.write(atom.read())

    with zipfile.ZipFile(r'atom-shell.zip') as f:
        f.extractall(r'atom-shell')
