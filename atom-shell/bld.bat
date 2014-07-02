pushd %RECIPE_DIR%
python download_atom_windows.py
if errorlevel 1 exit 1

mkdir %SP_DIR%\atomshell
move atom-shell %SP_DIR%\atomshell\atomshell
move %RECIPE_DIR%\*.py %SP_DIR%\atomshell
if errorlevel 1 exit 1