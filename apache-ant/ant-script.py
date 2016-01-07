import os
import sys
from subprocess import Popen, call

PREFIX = os.environ["PREFIX"]
ANT_HOME = os.path.join(PREFIX, "share", "apache-ant")
ANT = os.path.join(ANT_HOME, "bin")
JAVA_HOME = os.path.join(PREFIX, "Library")
JRE_HOME = os.path.join(JAVA_HOME, "jre")

os.environ["ANT_HOME"] = ANT_HOME
os.environ["ANT"] = ANT
os.environ["JAVA_HOME"] = JAVA_HOME
os.environ["JRE_HOME"] = JRE_HOME

print("""
Setting up ANT_HOME for ant to {} ...
Launching ant ...

""".format(ANT_HOME))

if "win" in sys.platform:
    call([os.path.join(ANT, "ant.cmd"), sys.argv[1]])
else:
    call([os.path.join(ANT, "ant"), sys.argv[1]])