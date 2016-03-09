%PYTHON% setup.py install
if errorlevel 1 exit 1



REM xcopy %SRC_DIR%\IPconverter\* %SP_DIR%\viper\IPconverter /s /i
REM xcopy %SRC_DIR%\IPslider\* %SP_DIR%\viper\IPslider /s /i
REM xcopy %SRC_DIR%\viper.py %SP_DIR%
REM echo.>%SP_DIR%\viper\__init__.py  