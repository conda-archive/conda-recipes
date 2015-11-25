from __future__ import print_function, unicode_literals, division

import argparse
import glob
from os.path import exists, join, abspath, split, isdir
import subprocess as sp
import sys
import time
import traceback
import yaml


DEFAULT_ANACONDA_ARCH = [
      'linux-32',
      'linux-64',
      'osx-32',
      'osx-64',
      'win-32',
      'win-64',
]

BINSTAR_YAML_TEMPLATE = {
         'after_failure': ['echo "after_failure!"'],
         'after_script': ['echo "conda-recipes:{package}:$BINSTAR_BUILD_RESULT" | tee artifact1.txt'],
         'after_success': ['echo "after_success!"'],
         'before_script': ['echo "before_script!"'],
         'build_targets': ['conda'],
         'engine': 'engine',
         'package': 'package',
         'platform': DEFAULT_ANACONDA_ARCH,
         'install': {'r': ['conda build . -c r'],
                     'python': ['conda build .'],
                     'other': ['conda build .'],
         },
         'user': 'user'
    }

def cmd(args, cwd='.'):
    proc = sp.Popen(args, stdout=sp.PIPE,
                    stderr=sp.PIPE, cwd=cwd)
    while proc.poll is None:
        time.sleep(1)
    out = proc.stdout.read().decode()
    err = proc.stderr.read().decode()
    return proc.returncode, out, err

def raise_or_not(args, msg):
    if args.exception_action == 'raise':
        raise ValueError(msg)
    print(msg, file=sys.stderr)

def choose_engine_install(meta, args):
    reqs = meta.get('requirements', {})
    build_reqs = reqs.get('build', None)
    run_reqs = reqs.get('run', None)
    if build_reqs is None:
        build_reqs = []
    if run_reqs is None:
        run_reqs = []
    b = [_.strip().lower() for _ in build_reqs + run_reqs]
    engine, install = [],[]
    if 'python' in b:
        engine = ['python']
        install = BINSTAR_YAML_TEMPLATE['install']['python']
    if 'r' in b:
        engine += ['r -c r']
        install += BINSTAR_YAML_TEMPLATE['install']['r']
    if not install:
        install = BINSTAR_YAML_TEMPLATE['install']['other']
    return engine, install

create_package_cmd = 'anaconda package --create {username}/{package}'
build_submit_cmd = 'anaconda build submit {package_file} --queue {queue} --channel {channel}'

def submit_package(args, top_dir, package_name):
    with open(join(top_dir, package_name, '.binstar.yml'), 'r') as f:
        binstar_yml = yaml.load(f.read())
    create = create_package_cmd.format(username=binstar_yml['user'],
                                       package=package_name).split()
    fil = join(top_dir, package_name)
    build = build_submit_cmd.format(package_file=fil,
                                    queue=args.queue,
                                    channel=args.channel).split()
    returncode2, out2, err2 = cmd(create, cwd=top_dir)
    if returncode2:
        raise ValueError('{} failed with {}, {}'.format(create, out2, err2))
    returncode3, out3, err3 = cmd(build, cwd=top_dir)
    print('Submitted:',build,'\n\n', out3 + '\n\n' + err3)
    if returncode3:
        raise ValueError('{} failed with {}, {}'.format(build, out3, err3))

def on_each_package(args, top_dir, package_name):
    if args.action == 'edit':
        meta_file = join(top_dir, package_name, 'meta.yaml')
        if not exists(meta_file):
            has_subdirs = False
            for try_levels in range(1,10):
                parts = (top_dir, package_name,) + ('*',) * try_levels
                parts = parts + ('meta.yaml',)
                if glob.glob(join(*parts)):
                    has_subdirs = True

            if not has_subdirs:
                msg = "Package {} in top_dir {} has no meta.yaml"
                msg = msg.format(package_name, top_dir)
                raise ValueError(msg)
            else:
                return
        with open(meta_file, 'r') as f:
            meta = yaml.load(f.read())
        binstar_yml_file = join(top_dir, package_name, '.binstar.yml')
        if args.yaml_load_existing and exists(binstar_yml_file):
            with open(binstar_yml_file, 'r') as f:
                binstar_yml = yaml.load(f.read())
        else:
            binstar_yml = BINSTAR_YAML_TEMPLATE.copy()
        eng, install = choose_engine_install(meta, args)
        binstar_yml['engine'], binstar_yml['install'] = eng, install
        binstar_yml['package'] = package_name
        binstar_yml['user'] = args.anaconda_upload_user
        if '{package}' in binstar_yml['after_script'][0]:
            binstar_yml['after_script'][0] = binstar_yml['after_script'][0].format(package=package_name)
        binstar_yml['platform'] = args.platforms
        with open(binstar_yml_file, 'w') as f:
            yaml.safe_dump(binstar_yml, f, default_flow_style=False)
    if args.action == 'submit':
        submit_package(args, top_dir, package_name)

def unpack_package_spec(args):
    for package in args.package_spec:
        if isdir(package):
            parts = list(filter(None, split(abspath(package))))
            top_dir, package_name = parts
            yield top_dir, package_name


def cli(parse_this_instead=None):
    parser = argparse.ArgumentParser(description='Tools for anaconda-build with conda-recipes')
    action = parser.add_subparsers(
        dest="action"
    )

    submit = action.add_parser('submit')
    parg = 'package_spec'
    pkwargs = {'nargs':'+',
               'help': 'Package(s) to build on anaconda.org'
               }
    submit.add_argument(parg, **pkwargs)
    submit.add_argument('queue',
                        help="anaconda-build queue of the form USERNAME/QUEUE")
    submit.add_argument('--channel',
                        help='Channel in anaconda.org into which to upload.  Default: dev',
                        default='dev')
    edit = action.add_parser('edit')
    edit.add_argument(parg, **pkwargs)

    edit.add_argument('anaconda_upload_user',
                        help='anaconda.org username for .binstar.yml builds')
    edit.add_argument('--platforms',
                        help='Platform(s) on which to build on anaconda.org. '
                             '\n\t\tChoices: %(choices)s'
                             '\n\t\tDefault:%(default)s',
                        default=DEFAULT_ANACONDA_ARCH,
                        nargs="*")
    edit.add_argument('--yaml-load-existing',
                        action='store_true',
                        help='Do not replace .binstar.yml with '
                             'template but read it as template if existing')
    arg = '--exception-action'
    kwargs = {'help':'"raise" or "stringify" errors',
     'default':"raise",
 }
    edit.add_argument(arg, **kwargs)
    submit.add_argument(arg, **kwargs)
    if parse_this_instead is None:
        return parser.parse_args()
    return parser.parse(parse_this_instead)

def main(parse_this_instead=None):
    args = cli(parse_this_instead)
    for platform in getattr(args, 'platforms', []):
        if not platform in DEFAULT_ANACONDA_ARCH:
            msg =  'Invalid --platform: {0}'.format(platform)
            msg += '.\n\tChoose from {0}'.format(DEFAULT_ANACONDA_ARCH)
            raise ValueError(msg)
    failed_packages = []
    for top_dir, package_name in unpack_package_spec(args):
        try:
            on_each_package(args, top_dir, package_name)
        except Exception as e:
            msg = "{}\n\t\t{}".format(repr(e), traceback.format_exc())
            raise_or_not(args, msg)
            failed_packages.append((package_name, repr(e)))
    if failed_packages:
        failed_str = "\n\t\t".join("\t".join(_) for _ in failed_packages)
        print('ERROR: Exceptions encountered on packages\n\n\t\t', failed_str)

if __name__ == "__main__":
    main()