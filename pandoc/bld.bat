msiexec /a pandoc-%PKG_VERSION%-windows.msi /qb TARGETDIR=%PREFIX%
mkdir %SCRIPTS%
move %PREFIX%\Pandoc\*.exe %SCRIPTS%
del /q %PREFIX%\Pandoc
