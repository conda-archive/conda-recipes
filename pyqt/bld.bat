:: assumes executable was installed to C:\staging, and that the documentation,
:: examples, and start menu shortcuts were not selected for installation

xcopy C:\staging\Lib %PREFIX%\Lib /e /i /q
del %SP_DIR%\sip.pyd
del %SP_DIR%\PyQt4\sip.exe
del %SP_DIR%\PyQt4\qt.conf
del %SP_DIR%\PyQt4\Uninstall.exe
move %SP_DIR%\PyQt4\sip %PREFIX%\sip

mkdir %PREFIX%\Scripts

@echo off
echo @echo off > %PREFIX%\Scripts\pyuic.bat
echo "%%~dp0\..\python.exe" "%%~dp0\..\Lib\site-packages\PyQt4\uic\pyuic.py" %%* >> %PREFIX%\Scripts\pyuic.bat

echo @echo off > %PREFIX%\Scripts\pyrcc4.bat
echo "%%~dp0\..\Lib\site-packages\PyQt4\pyrcc4" %%* >> %PREFIX%\Scripts\pyrcc4.bat
@echo on