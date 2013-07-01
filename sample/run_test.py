import sys
import pycosat
import test_pycosat

assert test_pycosat.run().wasSuccessful()

if sys.platform != 'win32':
    assert pycosat.__version__ == '0.6.0'

sys.stdout.write("The answer is: %d\n" % test_pycosat.foo)
assert test_pycosat.foo == 42
