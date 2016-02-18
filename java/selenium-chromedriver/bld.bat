for /R "%SRC_DIR%" %%f in (*.exe) do copy %%f "%LIBRARY_BIN%"
if errorlevel 1 exit 1