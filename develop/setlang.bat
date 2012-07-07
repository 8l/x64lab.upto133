@echo off

IF "%1"=="" ( 
 @del plugin\lang\en\lang.dll
 fasm plugin\lang\en\lang.asm
  IF ERRORLEVEL 1 GOTO :err_exit
 ) else (
 @del plugin\lang\%1\lang.dll
 fasm plugin\lang\%1\lang.asm
  IF ERRORLEVEL 1 GOTO :err_exit
)

:err_exit
