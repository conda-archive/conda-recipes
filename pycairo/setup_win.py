
import distutils.core      as dic
import distutils.dir_util  as dut
import distutils.file_util as fut
import distutils.sysconfig as dsy
import os
import sys

pycairo_version        = '1.10.0'
python_version_required = (2,7)
config_file    = 'src/config.h'

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
  libraries    = ['cairo'],
  runtime_library_dirs = []
  )


dic.setup(
  name = "pycairo",
  version = pycairo_version,
  description = "python interface for cairo",
  ext_modules = [cairo],
  data_files = [
    ('include/pycairo', ['src/pycairo.h']),
    (os.path.join(dsy.get_python_lib(), 'cairo'),
     ['src/__init__.py']),
    ],
  )
