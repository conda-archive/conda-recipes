
set DN=%LIBRARY_BIN%\datanitro-trial

copy %RECIPE_DIR%\license.txt %DN%-license.txt
copy %RECIPE_DIR%\post-link.bat %DN%-post-link.bat
copy %RECIPE_DIR%\post-unlink.bat %DN%-post-unlink.bat

copy DataNitroAnacondaTrialSetup.exe %DN%-setup.exe

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
