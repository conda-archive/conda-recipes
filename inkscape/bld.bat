7za x Inkscape-0.91-1-win64.7z -o%SRC_DIR%
rmdir /s/q %LIBRARY_PREFIX%
move %SRC_DIR%\inkscape %LIBRARY_PREFIX%
rem mkdir %SCRIPTS%
@echo start /b /wait cmd /c ^"%%~dp0..\Library\inkscape.com %%*^" > %SCRIPTS%\inkscape.bat
