copy %RECIPE_DIR%\setup_win.py %SRC_DIR%\setup.py

:: Extension is not working on Python 3.5, so we're using Gohlke's wheels for now
if %PY_VER%==3.5 (
    if %ARCH%==64 (
        pip install http://www.lfd.uci.edu/~gohlke/pythonlibs/xmshzit7/pycairo-1.10.0-cp35-none-win_amd64.whl
    ) else (
        pip install http://www.lfd.uci.edu/~gohlke/pythonlibs/xmshzit7/pycairo-1.10.0-cp35-none-win32.whl
    )
) else (
    python setup.py install
)
