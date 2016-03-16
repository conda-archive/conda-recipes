import os
import pytest
import raml

print('raml.__version__: %s' % raml.__version__)
pytest.main(['--ignore', os.path.join(os.environ['SRC_DIR'], '_test/lib'),
             os.path.join(os.environ['SRC_DIR'], '_test/')])
