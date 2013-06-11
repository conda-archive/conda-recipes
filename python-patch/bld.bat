mkdir %PREFIX%\Scripts
copy %RECIPE_DIR%\patch.py %PREFIX%\Scripts
if errorlevel 1 exit 1
