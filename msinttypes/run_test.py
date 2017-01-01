import os
import sys

inc = os.path.join(sys.prefix, 'Library', 'include')
assert os.path.isfile(os.path.join(inc, 'stdint.h'))
assert os.path.isfile(os.path.join(inc, 'inttypes.h'))
