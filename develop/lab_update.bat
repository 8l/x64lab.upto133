@echo off
 call build_all.bat
  IF ERRORLEVEL 1 GOTO err_exit

copy x64lab.exe ..\ /Y
copy x64lab.exe.manifest ..\ /Y
copy version.txt ..\ /Y
copy LICENSE.htm ..\ /Y

copy plugin\lang.dll ..\plugin /Y
copy plugin\dock64.dll ..\plugin /Y
copy plugin\bk64.dll ..\plugin /Y
copy plugin\top64.dll ..\plugin /Y
copy plugin\Scilexer64.dll ..\plugin /Y

set /p vers=<version.txt
date/T >tmpfile.tmp
set /p newdate=<tmpfile.tmp

echo.> tmpfile.tmp
echo - version %vers% released on %newdate% >> tmpfile.tmp
type WHATSNEW.TXT >> tmpfile.tmp
copy tmpfile.tmp WHATSNEW.TXT /Y
del tmpfile.tmp
copy WHATSNEW.TXT ..\ /Y

set vers=
set newdate=


:err_exit
	