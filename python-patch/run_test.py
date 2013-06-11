import subprocess

subprocess.check_call(["patch.py", "testfile.patch"])
with open("testfile") as f1:
    testfile1 = f1.read()
with open("testfile2") as f2:
    testfile2 = f2.read()

assert testfile1 == testfile2
