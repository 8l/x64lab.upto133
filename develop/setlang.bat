@echo off
 @del plugin\lang.dll

IF "%1"=="" ( 
 fasm plugin\lang\lang.en.asm
  IF ERRORLEVEL 1 GOTO :err_exit
 copy plugin\lang\lang.en.dll plugin\lang.dll
 ) else (
 fasm plugin\lang\lang.%1%.asm
  IF ERRORLEVEL 1 GOTO :err_exit
 copy plugin\lang\lang.%1%.dll plugin\lang.dll
)

:err_exit
