from os import environ
import sys

PREFIX = environ['PREFIX']
#PREFIX = "C:\Anaconda\envs\_build_placehold_placehold_placehold_placehold_placehold_placeh"
PRL_PREFIX = PREFIX.replace('\\', '\\\\') + '\\\\Library\\\\lib\\\\qt5'
# must include an empty string in the *last* position of this list:
LIBS = ['\\\\Qt5Core.lib', '\\\\Qt5Gui.lib', '\\\\Qt5Widgets.lib', '']
PKG_VERSION = environ['PKG_VERSION']
#PKG_VERSION = "5.3.1"
RECIPE_DIR = environ['RECIPE_DIR']
#RECIPE_DIR = "C:\Users\darren\Documents\GitHub\conda-recipes\qt5"

with open('%s/%s_patch_files.txt' % (RECIPE_DIR, PKG_VERSION), 'r') as names:
    for filename in names:
        filename = filename[:-1]
        with open('%s/%s' % (PREFIX, filename), 'rb') as f:
            data = f.read()
        for lib in LIBS:
            old = (PRL_PREFIX+lib).encode('utf-8')
            new = b'"%s"' % (old.replace(b'\\\\', b'/'))
            data = data.replace(old, new)
        with open('%s/%s' % (PREFIX, filename), 'wb') as f:
            f.write(data)
