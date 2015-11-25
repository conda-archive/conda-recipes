from __future__ import print_function, unicode_literals, division

import argparse
import glob
from os.path import exists, join, abspath, split, walk, isdir
import subprocess as sp
import sys
import time
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
    create = create_package_cmd.format(username=args.anaconda_upload_user,
                                       package=package_name).split()
    fil = join(top_dir, package_name)
    build = build_submit_cmd.format(package_file=fil,
                                    queue=args.queue,
                                    channel=args.channel).split()
    returncode2, out2, err2 = cmd(create, cwd=top_dir)
    if returncode2:
        raise_or_not(args, '{} failed with {}, {}'.format(create, out2, err2))
    returncode3, out3, err3 = cmd(build, cwd=top_dir)
    print('Submitted:',build,'\n\n', out3 + '\n\n' + err3)
    if returncode3:
        raise_or_not(args, '{} failed with {}, {}'.format(build, out3, err3))

def on_each_package(args, top_dir, package_name):
    meta_file = join(top_dir, package_name, 'meta.yaml')
    if not exists(meta_file):
        msg = "Package {} in top_dir {} has no meta.yaml"
        msg = msg.format(package_name, top_dir)
        raise_or_not(args, msg)
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
    for platform in args.anaconda_build_platforms:
        if not platform in DEFAULT_ANACONDA_ARCH:
            msg =  'Invalid --anaconda-build-platform: {0}'.format(platform)
            msg += '.\n\tChoose from {0}'.format(DEFAULT_ANACONDA_ARCH)
            raise ValueError(msg)
    binstar_yml['platform'] = args.anaconda_build_platforms
    with open(binstar_yml_file, 'w') as f:
        yaml.safe_dump(binstar_yml, f, default_flow_style=False)
    if args.submit:
        submit_package(args, top_dir, package_name)

def unpack_package_spec(args):
    for package in args.package_spec:
        if isdir(package):
            parts = list(filter(None, split(abspath(package))))
            print(parts)
            top_dir, package_name = parts
            print(top_dir, package_name)
            yield top_dir, package_name


def cli(parse_this_instead=None):
    parser = argparse.ArgumentParser(description='Tools for anaconda-build with conda-recipes')
    parser.add_argument('queue',
                        help="anaconda-build queue of the form USERNAME/QUEUE")
    parser.add_argument('package_spec',
                        nargs='+',
                        help='Package(s) to build on anaconda.org')
    parser.add_argument('anaconda_upload_user',
                        help='anaconda.org username for .binstar.yml builds')
    parser.add_argument('--channel',
                        help='Channel in anaconda.org into which to upload.  Default: dev',
                        default='dev')
    parser.add_argument('--submit',
                        action="store_true",
                        help='Submit to anaconda.org')
    parser.add_argument('--anaconda-build-platforms',
                        help='Platform(s) on which to build on anaconda.org. '
                             '\n\t\tChoices: %(choices)s'
                             '\n\t\tDefault:%(default)s',
                        default=DEFAULT_ANACONDA_ARCH,
                        nargs="*")
    parser.add_argument('--yaml-load-existing',
                        action='store_true',
                        help='Do not replace .binstar.yml with '
                             'template but read it as template if existing')
    parser.add_argument('--top-dir',
                        help="Packages reside in this directory",
                        default=abspath('.'))
    parser.add_argument('--exception-action',
                        help='"raise" or "stringify" errors',
                        default="raise")
    if parse_this_instead is None:
        return parser.parse_args()
    return parser.parse(parse_this_instead)

def main(parse_this_instead=None):
    args = cli(parse_this_instead)
    for top_dir, package_name in unpack_package_spec(args):
        on_each_package(args, top_dir, package_name)

if __name__ == "__main__":
    main()