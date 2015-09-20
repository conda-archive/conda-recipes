msiexec /a inkscape-%PKG_VERSION%.msi /qb TARGETDIR=%PREFIX%
move %PREFIX%\PFiles\Inkscape %PREFIX%\lib

mkdir %SCRIPTS%
@echo start /b /wait cmd /c ^"%%~dp0..\lib\inkscape.com %%*^" > %SCRIPTS%\inkscape.bat
