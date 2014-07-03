mkdir %PREFIX%\atom-shell
if errorlevel 1 exit 1

xcopy /E .\* %PREFIX%\atom-shell\
if errorlevel 1 exit 1

mkdir %PREFIX%\Scripts
if errorlevel 1 exit 1

set bin=%PREFIX%\Scripts\atomshell.bat

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
echo %PREFIX%\atom-shell\atom.exe %%params%% >> %bin%
