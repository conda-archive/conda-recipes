cd sip-4.16.2

set PYQTDIR=%PREFIX%\Lib\site-packages\PyQt4

"%PYTHON%" configure.py -b "%PYQTDIR%" -v "%PYQTDIR%\sip" -e "%PYQTDIR%\include"
if errorlevel 1 exit 1

copy sipconfig.py "%PREFIX%\Lib\site-packages\sipconfig.py"
if errorlevel 1 exit 1
