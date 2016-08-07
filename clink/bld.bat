@mkdir %SCRIPTS% 2> NUL
@for %%f in (clink.bat clink.lua clink_inputrc_base clink_x64.exe clink_dll_x64.dll clink_x86.exe clink_dll_x86.dll) do (
    move %SRC_DIR%\%%f %SCRIPTS%
    @if errorlevel 1 exit 1
)
xcopy %RECIPE_DIR%\activate_clink.bat %PREFIX%\etc\conda\activate.d\