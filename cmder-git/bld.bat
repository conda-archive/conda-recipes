
mkdir "%SCRIPTS%"
7za x "-o%SCRIPTS%" *.7z
copy "%RECIPE_DIR%\cmder.bat" "%SCRIPTS%\"
copy "%RECIPE_DIR%\cmder.ico" "%MENU_DIR%"


rem vim:set ts=8 sw=4 sts=4 tw=78 et:
