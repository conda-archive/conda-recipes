import os

import nose

import smqtk

initial_dir = os.getcwd()
my_package_file = os.path.abspath(smqtk.__file__)
my_package_dir = os.path.dirname(my_package_file)
nose_argv = ['--with-doctest', '--exclude-dir=web']
nose_argv += ['--detailed-errors', '--exe']
os.chdir(my_package_dir)
try:
    nose.run(argv=nose_argv)
finally:
    os.chdir(initial_dir)
