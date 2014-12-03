@rem cd src\gnuwin32
@rem make

@rem http://cran.r-project.org/bin/windows/base/rw-FAQ.html#Can-I-customize-the-installation_003f
@rem The easiest way to configure this is to run the installer with
@rem /SAVEINF="installer_settings.inf" with the desired settings and cancel just
@rem before the install begins.
R-3.1.2-win.exe /SILENT /LOADINF="%RECIPE_DIR%\installer_settings.inf" /DIR="%PREFIX%"
