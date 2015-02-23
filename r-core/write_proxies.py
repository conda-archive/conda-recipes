from __future__ import print_function
import os
import sys

def main():
    prefix = os.environ['PREFIX']
    thisdir = os.path.dirname(__file__)

    arch = os.environ['ARCH']
    if arch == '32':
        bindir = os.path.join(prefix, 'R', 'bin', 'i386')
    elif arch == '64':
        bindir = os.path.join(prefix, 'R', 'bin', 'x64')
    else:
        raise ValueError("Unexpected ARCH: %s" % arch)

    with open(os.path.join(thisdir, 'proxy-%s.bat' % arch)) as f:
        proxy = f.read()

    for fn in os.listdir(bindir):
        if not fn.endswith('.exe'):
            continue

        script_name = fn.rsplit('.exe', 2)[0]

        with open(os.path.join(prefix, 'Scripts', '%s.bat' % script_name), 'w') as f:
            print("Writing proxy for %s" % script_name)
            f.write(proxy)

if __name__ == '__main__':
    sys.exit(main())
