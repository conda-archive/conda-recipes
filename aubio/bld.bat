make checkwaf
if errorlevel 1 exit 1

"%PYTHON%" waf configure --prefix=%PREFIX%
if errorlevel 1 exit 1

"%PYTHON%" waf build
if errorlevel 1 exit 1

"%PYTHON%" waf install
if errorlevel 1 exit 1

cd python

"%PYTHON%" setup.py build
if errorlevel 1 exit 1

"%PYTHON%" setup.py install
if errorlevel 1 exit 1

