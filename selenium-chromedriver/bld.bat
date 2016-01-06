for /R "%SRC_DIR%" %%f in (*.exe) do copy %%f "%PYTHONPATH%/Scripts"
if errorlevel 1 exit 1