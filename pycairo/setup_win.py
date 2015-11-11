#
# Based on https://github.com/hydrargyrum/pycairo/blob/master/setup.py
#
# Modifications:
# 1. Don't use pkg-config
# 2. Make it work for Python 2 and 3
# 3. This only works for conda-build
#

import distutils.core      as dic
import distutils.dir_util  as dut
import distutils.file_util as fut
import distutils.sysconfig as dsy
import os
import sys

pycairo_version        = '1.10.0'
python_version_required = (2,7)
config_file    = 'src/config.h'

PY3 = sys.version[0] == '3'


def createConfigFile(ConfigFile):
  print('creating %s' % ConfigFile)
  v = pycairo_version.split('.')

  with open(ConfigFile, 'w') as fo:
    fo.write ("""\
// Configuration header created by setup.py - do not edit
#ifndef _CONFIG_H
#define _CONFIG_H 1

#define PYCAIRO_VERSION_MAJOR %s
#define PYCAIRO_VERSION_MINOR %s
#define PYCAIRO_VERSION_MICRO %s
#define VERSION "%s"

#endif // _CONFIG_H
""" % (v[0], v[1], v[2], pycairo_version)
            )

if sys.version_info < python_version_required:
  raise SystemExit('Error: Python >= %s is required' %
                   (python_version_required,))

createConfigFile(config_file)

if PY3:
    py_ver =    sys.version[:3].replace('.', '')
    libraries = ['cairo', 'python'+py_ver]
    include =   ['src/py3cairo.h']
else:
    libraries = ['cairo']
    include =   ['src/pycairo.h']

cairo = dic.Extension(
  name = 'cairo._cairo',
  sources = ['src/cairomodule.c',
             'src/context.c',
             'src/font.c',
             'src/matrix.c',
             'src/path.c',
             'src/pattern.c',
             'src/surface.c',
             ],
  include_dirs = [os.environ['PREFIX']+'\\include', os.environ['LIBRARY_INC']+'\\cairo'],
  library_dirs = [os.environ['PREFIX']+'\\Lib', os.environ['LIBRARY_LIB']],
  libraries    = libraries,
  runtime_library_dirs = []
  )


dic.setup(
  name = "pycairo",
  version = pycairo_version,
  description = "python interface for cairo",
  ext_modules = [cairo],
  data_files = [
    ('include/pycairo', include),
    (os.path.join(dsy.get_python_lib(), 'cairo'),
     ['src/__init__.py']),
    ],
  )
