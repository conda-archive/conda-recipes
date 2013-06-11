import subprocess

import sys

if sys.platform == 'win32':
    command = 'patch.bat'
else:
    command = 'patch.py'

subprocess.check_call([command, "testfile.patch"])
with open("testfile") as f1:
    testfile1 = f1.read()
with open("testfile2") as f2:
    testfile2 = f2.read()

assert testfile1 == testfile2
