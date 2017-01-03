import os
from conda_build.metadata import MetaData
import requests
import hashlib
import tarfile
import tempfile
from glob import glob
from shutil import move, copy
from os.path import join, normpath, dirname
from os import makedirs, getenv
from sys import exit
import patch
import re


def get_tar_xz(url, md5):
    tmpdir = tempfile.mkdtemp()
    urlparts = requests.packages.urllib3.util.url.parse_url(url)
    fname = urlparts.path.split('/')[-1]
    sig = hashlib.md5()
    tmp_tar_xz = join(tmpdir, fname)
    if urlparts.scheme == 'file':
        path = re.compile('^file://').sub('', url).replace('/', os.sep)
        copy(path, tmp_tar_xz)
        with open(tmp_tar_xz, "rb") as tar_xz:
            for block in iter(lambda: tar_xz.read(1024), b""):
                sig.update(block)
    else:
        with open(tmp_tar_xz, 'wb') as tar_xz:
            response = requests.get(url, stream=True)
            for block in response.iter_content(1024):
                sig.update(block)
                tar_xz.write(block)
    if sig.hexdigest() != md5:
        print(
            'ERROR: md5 sum mismatch expected %s, got %s' %
            (md5, sig.hexdigest()))
        exit(1)
    return tmp_tar_xz


def main():
    recipe_dir = os.environ["RECIPE_DIR"]
    conda_platform = 'win-32' if os.environ["ARCH"] == '32' else 'win-64'
    prefix = os.environ['PREFIX']

    metadata = MetaData(recipe_dir)
    msys2_tar_xz_url = metadata.get_section(
        'extra')['msys2-binaries'][conda_platform]['url']
    msys2_md5 = metadata.get_section(
        'extra')['msys2-binaries'][conda_platform]['md5']
    mv_srcs_list = metadata.get_section(
        'extra')['msys2-binaries'][conda_platform]['mv-srcs']
    mv_dsts_list = metadata.get_section(
        'extra')['msys2-binaries'][conda_platform]['mv-dsts']
    msys2_tar_xz = get_tar_xz(msys2_tar_xz_url, msys2_md5)
    tar = tarfile.open(msys2_tar_xz, 'r|xz')
    tar.extractall(path=prefix)
    for pacman_file in ('.BUILDINFO', '.MTREE', '.PKGINFO', '.INSTALL'):
        try:
            os.remove(join(prefix, pacman_file))
        except:
            pass

    try:
        patches = metadata.get_section(
            'extra')['msys2-binaries'][conda_platform]['patches']
    except:
        patches = []
    if len(patches):
        for patchname in patches:
            patchset = patch.fromfile(join(getenv('RECIPE_DIR'), patchname))
            patchset.apply(1, root=prefix)

    # shutil is a bit funny (like mv) with regards to how it treats
    # the destination depending on whether it is an existing directory or not
    # (i.e. moving into that versus moving as that).
    # Therefore, the rules employed are:
    # 1. If mv_dst ends with a '/' it is a directory that you want mv_src
    #    moved into.
    # 2. If mv_src has a wildcard, mv_dst is a directory that you want mv_src
    #    moved into.
    # In these cases we makedirs(mv_dst) and then call move(mv_src, mv_dst)
    # .. otherwise we makedirs(dirname(mv_dst)) and call move(mv_src, mv_dst)
    # .. however, if no mv_srcs exist we don't makedirs at all.
    for mv_src, mv_dst in zip(mv_srcs_list, mv_dsts_list):
        mv_dst_definitely_dir = False
        mv_srcs = glob(join(prefix, normpath(mv_src)))
        # Prevent the 'Scripts' subfolder from being moved into the final package.
        mv_srcs = [m for m in mv_srcs if not re.match('.*\\Scripts$', m)]
        if '*' in mv_src or mv_dst.endswith('/') or len(mv_srcs) > 1:
            mv_dst_definitely_dir = True
        if len(mv_srcs):
            mv_dst = join(prefix, normpath(mv_dst))
            mv_dst_mkdir = mv_dst
            if not mv_dst_definitely_dir:
                mv_dst_mkdir = dirname(mv_dst_mkdir)
            try:
                makedirs(mv_dst_mkdir)
            except:
                pass
            for mv_src_item in mv_srcs:
                move(mv_src_item, mv_dst)
    tar.close()

if __name__ == "__main__":
    main()
