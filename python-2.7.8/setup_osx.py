# used to build the tk interface on 64-bit darwin
import sys
from distutils.core import setup, Extension


setup(
    ext_modules = [
        Extension(
            '_ssl', ['_ssl.c'],
            libraries = ['ssl', 'crypto'],
            depends = ['socketmodule.h'],
            include_dirs = [sys.prefix + '/include'],
            library_dirs = [sys.prefix + '/lib'],
        ),
        Extension(
            '_hashlib', ['_hashopenssl.c'],
            libraries = ['ssl', 'crypto'],
            include_dirs = [sys.prefix + '/include'],
            library_dirs = [sys.prefix + '/lib'],
        ),
        Extension(
            '_tkinter', ['_tkinter.c', 'tkappinit.c'],
            define_macros=[('WITH_APPINIT', 1)],
            libraries=['tcl8.5', 'tk8.5'],
            include_dirs = [sys.prefix + '/include', '/usr/X11R6/include'],
            library_dirs = [sys.prefix + '/lib'],
        ),
    ],
)
