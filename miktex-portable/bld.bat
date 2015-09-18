%SCRIPTS%\7za x .\miktex-portable-2.9.5719.exe -yo.\miktex-portable-work
xcopy .\miktex-portable-work\miktex\bin %SCRIPTS% /s /e
rmdir .\miktex-portable-work /s /q