innoextract -e rro.exe
if errorlevel 1 exit 1

mkdir -p %PREFIX%\R
cp -Rv app/* %PREFIX%\R
if errorlevel 1 exit 1

