FOR /F "delims=" %%i IN ('conda info --root') DO set "CONDA_PYTHON=%%i\python.exe"

%CONDA_PYTHON% %RECIPE_DIR%\..\..\common-scripts\msys2-binary-convert.py
