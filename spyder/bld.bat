python setup.py install
if errorlevel 1 exit 1

del %SCRIPTS%\spyder_win_post_install.py

rd /s /q %SP_DIR%\pyflakes
