#
# Based on
# https://github.com/hydrargyrum/pycairo/blob/master/setup.py
#
# Modifications:
# 1. Make it work for Python 2 and 3
#

from __future__ import print_function

import distutils.core      as dic
import distutils.dir_util  as dut
import distutils.file_util as fut
import distutils.sysconfig as dsy
import io
import os
import subprocess
import sys

pycairo_version        = '1.10.0'
cairo_version_required = '1.10.2'
python_version_required = (2,7)
pkgconfig_file = 'py3cairo.pc'
config_file    = 'src/config.h'

PY3 = sys.version[0] == '3'

def call(command):
  pipe = subprocess.Popen(command, shell=True,
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)
  pipe.wait()
  return pipe

def pkg_config_version_check(pkg, version):
  check = '%s >= %s' % (pkg, version)
  pipe = call("pkg-config --print-errors --exists '%s'" % (check,))
  if pipe.returncode == 0:
    print(check, ' Successful')
  else:
    print(check, ' Failed')
    raise SystemExit(pipe.stderr.read().decode())

def pkg_config_parse(opt, pkg):
  check = "pkg-config %s %s" % (opt, pkg)
  pipe = call("pkg-config %s %s" % (opt, pkg))
  if pipe.returncode != 0:
    print(check, ' Failed')
    raise SystemExit(pipe.stderr.read().decode())

  output = pipe.stdout.read()
  output = output.decode() # get the str
  opt = opt[-2:]
  return [x.lstrip(opt) for x in output.split()]


def createPcFile(PcFile):
  print('creating %s' % PcFile)
  with open(PcFile, 'w') as fo:
    fo.write ("""\
prefix=%s

Name: Pycairo
Description: Python bindings for cairo
Version: %s
Requires: cairo
Cflags: -I${prefix}/include/pycairo
Libs:
""" % (sys.prefix, pycairo_version)
            )

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


pkg_config_version_check ('cairo', cairo_version_required)
if sys.platform == 'win32':
  runtime_library_dirs = []
else:
  runtime_library_dirs = pkg_config_parse('--libs-only-L', 'cairo')

createPcFile(pkgconfig_file)
createConfigFile(config_file)


if PY3:
    include =   ['src/py3cairo.h']
else:
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
  include_dirs = pkg_config_parse('--cflags-only-I', 'cairo'),
  library_dirs = pkg_config_parse('--libs-only-L', 'cairo'),
  libraries    = pkg_config_parse('--libs-only-l', 'cairo'),
  runtime_library_dirs = runtime_library_dirs,
  )

dic.setup(
  name = "pycairo",
  version = pycairo_version,
  description = "python interface for cairo",
  ext_modules = [cairo],
  data_files = [
    ('include/pycairo', include),
    ('lib/pkgconfig', [pkgconfig_file]),
    (os.path.join(dsy.get_python_lib(), 'cairo'),
     ['src/__init__.py']),
    ],
  )
