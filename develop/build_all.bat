echo off
 cscript version.vbs //nologo
 set /p vers=<version.txt
 echo. > version.inc
 echo define VERSION %vers% >> version.inc
 echo. >> version.inc

 @del x64labd.exe
 @del x64lab.exe

 call setlang.bat
   IF ERRORLEVEL 1 GOTO err_exit

 fasm plugin\top64.asm
   IF ERRORLEVEL 1 GOTO err_exit

 fasm plugin\bk64.asm
   IF ERRORLEVEL 1 GOTO err_exit

 fasm plugin\dock64.asm
   IF ERRORLEVEL 1 GOTO err_exit

 echo.
 fasm x64labd.asm
   IF ERRORLEVEL 1 GOTO err_exit
 echo.
 fasm x64lab.asm
   IF ERRORLEVEL 1 GOTO err_exit
 echo.

 echo --------- All Ok ----------

:err_exit
 set vers=

