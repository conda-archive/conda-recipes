import os
import sys
from subprocess import Popen, call

PREFIX = os.environ["PREFIX"]
M2_HOME = os.path.join(PREFIX, "share", "apache-maven")
M2 = os.path.join(M2_HOME, "bin")
JAVA_HOME = os.path.join(PREFIX, "Library")
JRE_HOME = os.path.join(JAVA_HOME, "jre")

os.environ["M2_HOME"] = M2_HOME
os.environ["M2"] = M2
os.environ["JAVA_HOME"] = JAVA_HOME
os.environ["JRE_HOME"] = JRE_HOME
os.environ["MAVEN_OPTS"] = "-Xms256m -Xmx512m"

print("""
Setting up M2_HOME for mvn to {} ...
Launching mvn ...

""".format(M2_HOME))

if "win" in sys.platform:
    call([os.path.join(M2, "mvn.cmd"), sys.argv[1]])
else:
    call([os.path.join(M2, "mvn"), sys.argv[1]])