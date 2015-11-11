
if %PY_VER%==2.7 (
    copy %RECIPE_DIR%\setup_win.py %SRC_DIR%\setup.py
)

python setup.py install
