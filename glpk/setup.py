from setuptools import setup, Extension
from os import environ

from Cython.Build import cythonize

module = Extension("spam",
                   sources=["spam.pyx"],
                   include_dirs=[environ.get("LIBRARY_INC", "")],
                   library_dirs=[environ.get("LIBRARY_LIB", "")],
                   libraries=["glpk"]
                   )

setup(name="spam",
      test_suite="spam.suite",
      ext_modules=cythonize([module]))