mkdir %PREFIX%\atom-shell
if errorlevel 1 exit 1

xcopy /E .\* %PREFIX%\atom-shell\
if errorlevel 1 exit 1

mkdir %SCRIPTS%
if errorlevel 1 exit 1

set bin=%SCRIPTS%\atomshell.bat

echo rem stackoverflow.com/questions/761615 >> %bin%
echo rem discard the first parameter >> %bin%

echo shift >> %bin%
echo set params=%%1 >> %bin%

echo :loop >> %bin%
echo shift >> %bin%
echo if [%%1]==[] goto endloop >> %bin%
echo set params=%%params%% %%1 >> %bin%
echo goto loop >> %bin%

echo :endloop >> %bin%
echo /opt/anaconda1anaconda2anaconda3\atom-shell\atom.exe %%params%% >> %bin%
