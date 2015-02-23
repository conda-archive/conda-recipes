@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

@rem Name of this file
set THISFILE=!%~nx0
@rem Path to this file (without the file name)
set THISPATH=%~dp0
@rem Remove the ".bat"
set EXEFILE=%THISFILE:~0,-4%

@rem Run the exe
"%~dp0\..\R\bin\i386\%EXEFILE%.exe" %*

ENDLOCAL
