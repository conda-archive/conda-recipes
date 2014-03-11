:: Original Strawberry Perl instructions (for reference)
:: -----------------------------------------------------
::
:: * Extract strawberry portable ZIP into e.g. c:\myperl\
::   Note: choose a directory name without spaces and non us-ascii characters
::
:: * Launch c:\myperl\portableshell.bat - it should open a command prompt window
::
:: * In the command prompt window you can:
::
::   1. run any perl script by launching
::
::      c:\> perl c:\path\to\script.pl
::
::   2. install additional perl modules (libraries) from http://www.cpan.org/ by
::
::      c:\> cpan Module::Name
::
::   3. run other tools included in strawberry like: perldoc, gcc, dmake ...
::
:: * If you want to use Strawberry Perl Portable not only from portableshell.bat,
::   you need to set the following environmental variables:
::
::   1. add c:\myperl\perl\site\bin, c:\myperl\perl\bin, and c:\myperl\c\bin
::      to PATH variable
::
::   2. set variable TERM=dumb

:: Copy everything to new portable perl directory
mkdir "%PREFIX%\myperl"
copy *.* "%PREFIX%\myperl"

:: Symlink bin directories to prefix's bin
IF NOT exist "%PREFIX%\bin" (
	mkdir "%PREFIX%\bin"
)
cd "%PREFIX%\myperl\perl\bin"
FOR /r %%X IN (*) DO (
	mklink %%X "%PREFIX%\bin\%%X"
)
cd "%PREFIX%\myperl\c\bin"
FOR /r %%X IN (*) DO (
	mklink %%X "%PREFIX%\bin\%%X"
)
