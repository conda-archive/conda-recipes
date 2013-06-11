mkdir "%PREFIX%\Scripts"
copy "%RECIPE_DIR%\patch.py" "%PREFIX%\Scripts\patch.py"
if errorlevel 1 exit 1
