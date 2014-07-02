#!/bin/python

import os
import sys
import subprocess

def main():
    if sys.platform.startswith('linux'):
        atom_path = os.path.abspath(os.path.join(os.path.dirname(__file__), 'atomshell'))
        atom_path = os.path.join(atom_path, 'atom')
    elif sys.platform.startswith('darwin'):
        atom_path = os.path.abspath(os.path.join(os.path.dirname(__file__), 'atomshell/Contents/MacOS'))
        atom_path = os.path.join(atom_path, 'Atom')
    elif sys.platform.startswith('win'):
        atom_path = os.path.abspath(os.path.join(os.path.dirname(__file__), 'atomshell'))
        atom_path = os.path.join(atom_path, 'atom.exe')

    subprocess.Popen(
        [atom_path] + sys.argv[1:],
        env=os.environ).communicate()

if __name__ == '__main__':
    main()
