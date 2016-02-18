import sys
from distutils.core import setup, Extension


setup(
    ext_modules = [
        Extension(
            'readline', ['readline.c'],
            libraries = ['readline'],#, 'ncursesw', 'tinfow'],
            include_dirs = [sys.prefix + '/include'],
            library_dirs = [sys.prefix + '/lib'],
        ),
    ],
)
