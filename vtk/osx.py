import os
from os.path import basename, join

import bt.macho as macho


PREFIX = os.getenv('PREFIX')
BIN = join(PREFIX, 'bin')
LIBVTK = join(PREFIX, 'lib/vtk-5.10')
SP_VTK = join(PREFIX, 'lib/python2.7/site-packages/vtk')


def ch_link_libvtk(path, link):
    if link.startswith('libpython'):
        return '@loader_path/../%s' % basename(link)

    if link.startswith('lib'):
        return '@loader_path/./%s' % basename(link)

def ch_link_bin(path, link):
    if link.startswith('libpython'):
        return '@loader_path/../lib/%s' % basename(link)

    if link.startswith('lib'):
        return '@loader_path/../lib/vtk-5.10/%s' % basename(link)

def ch_link_spvtk(path, link):
    if '/VTK5.10.1/' in link:
        return '@loader_path/../../../vtk-5.10/%s' % basename(link)

def main():
    for fn in os.listdir(LIBVTK):
        path = join(LIBVTK, fn)
        if macho.is_macho(path):
            macho.install_name_change(path, ch_link_libvtk)

    for fn in os.listdir(BIN):
        path = join(BIN, fn)
        if macho.is_macho(path):
            macho.install_name_change(path, ch_link_bin)

    for fn in os.listdir(SP_VTK):
        path = join(SP_VTK, fn)
        if macho.is_macho(path):
            macho.install_name_change(path, ch_link_spvtk)

if __name__ == '__main__':
    main()

