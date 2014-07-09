mkdir %PREFIX%\atom-shell
if errorlevel 1 exit 1

xcopy /E .\* %PREFIX%\atom-shell\
if errorlevel 1 exit 1

mkdir %SCRIPTS%
if errorlevel 1 exit 1

set bin=%SCRIPTS%\atomshell.bat
echo /opt/anaconda1anaconda2anaconda3\atom-shell\atom.exe %%* >> %bin%
