set DISTUTILS_USE_SDK=1

"%PYTHON%" setup.py configure --zmq "%PREFIX%"
if errorlevel 1 exit 1

"%PYTHON%" setup.py install
if errorlevel 1 exit 1
