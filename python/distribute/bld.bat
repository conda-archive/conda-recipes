python setup.py install
if errorlevel 1 exit 1

rd /s /q %SP_DIR%\distribute-%PKG_VERSION%-py%PY_VER%.egg\EGG-INFO
move %SRC_DIR%\distribute.egg-info %SP_DIR%
