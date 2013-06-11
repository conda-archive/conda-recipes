mkdir "%PREFIX%\Scripts"
copy "%RECIPE_DIR%\patch.py" "%PREFIX%\Scripts\patch"
if errorlevel 1 exit 1
