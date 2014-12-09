from __future__ import print_function
import os
import sys

def main():
    prefix = os.environ['PREFIX']
    thisdir = os.path.dirname(__file__)

    with open(os.path.join(thisdir, 'proxy.bat')) as f:
        proxy = f.read()

    for fn in os.listdir(os.path.join(prefix, 'R', 'bin', 'i386')):
        if not fn.endswith('.exe'):
            continue

        script_name = fn.rsplit('.exe', 2)[0]

        with open(os.path.join(prefix, 'Scripts', '%.exe' % script_name), 'w') as f:
            print("Writing proxy for %s" % script_name)
            f.write(proxy)

if __name__ == '__main__':
    sys.exit(main())
