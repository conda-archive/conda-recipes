@echo off
set PYFILE=%~f0
set PYFILE=%PYFILE:~0,-4%-script.py
"python.exe" "%PYFILE%" %*