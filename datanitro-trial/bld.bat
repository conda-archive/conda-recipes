
mkdir %SCRIPTS%

set DN=%SCRIPTS%\.datanitro-trial

copy %RECIPE_DIR%\license.txt %DN%-license.txt

copy DataNitroAnacondaTrialSetup.exe %DN%-setup.exe

rem vim:set ts=8 sw=4 sts=4 tw=78 et:
