7za x miktex-portable-%PKG_VERSION%.exe -o%PREFIX%\share

rem latex tools must be run from miktex tree
rem nbconvert uses pdflatex & bibtex
rem SCRIPTS dir is created by 7za install
@echo start /b /wait cmd /c ^"%%~dp0..\share\miktex\bin\pdflatex.exe %%*^" > %SCRIPTS%\pdflatex.bat
@echo start /b /wait cmd /c ^"%%~dp0..\share\miktex\bin\bibtex.exe %%*^" > %SCRIPTS%\bibtex.bat

for %%x in (adjustbox booktabs collectbox fancyvrb ifoddpage mptopdf ucs url) do %PREFIX%\share\miktex\bin\mpm --install %%x
