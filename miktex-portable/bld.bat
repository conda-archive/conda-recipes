mkdir "%PREFIX%\miktex-portable\"
if errorlevel 1 exit 1

"%SCRIPTS%\7za" x .\miktex-portable-2.9.5719.exe -yo"%PREFIX%\miktex-portable\"
if errorlevel 1 exit 1

for %%f in ("%PREFIX%\miktex-portable\miktex\bin\*.exe") do echo %%f %%* >> "%SCRIPTS%\%%~nf.bat"
if errorlevel 1 exit 1
