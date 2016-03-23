import os
import pytest
import ruamel_yaml

print('ruamel_yaml.__version__: %s' % ruamel_yaml.__version__)


pytest.main(['--ignore', os.path.join(os.environ['SRC_DIR'], '_test/lib'),
             os.path.join(os.environ['SRC_DIR'], '_test/')])
