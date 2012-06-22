REM usage:
REM -----> flbackup D:
REM create a dir D:\YYYY_MMDD-HHMM and copy all in it
REM -----> flbackup
REM create a subdir in the current dir
REM -----> flbackup D:\MYDIR
REM the same in MYDIR
REM

@echo off
set pathdir=%1

time/T > tmpfile.tmp
set /p newtime=<tmpfile.tmp
set hour=%newtime:~0,2%
set min=%newtime:~3,2%

date/T > tmpfile.tmp
set /p newdate=<tmpfile.tmp

set day=%newdate:~0,2%
set month=%newdate:~3,2%
set year=%newdate:~6,4%

set newdir=%year%_%month%%day%-%hour%%min%
IF "%1"=="" ( 
	set pathdir=%CD%
	)
echo ------ Creating dir [%newdir%]
echo ------ in [%pathdir%]
echo ------ %pathdir%\%newdir%
del tmpfile.tmp

md %pathdir%\%newdir%
copy *.* %pathdir%\%newdir%

md %pathdir%\%newdir%\config
xcopy config\*.* %pathdir%\%newdir%\config\*.* /E

md %pathdir%\%newdir%\equates
xcopy equates\*.* %pathdir%\%newdir%\equates\*.* /E

md %pathdir%\%newdir%\tests
xcopy tests\*.* %pathdir%\%newdir%\tests\*.* /E

md %pathdir%\%newdir%\macro
copy macro\*.* %pathdir%\%newdir%\macro\*.*

md %pathdir%\%newdir%\ide
copy ide\*.* %pathdir%\%newdir%\ide\*.*

md %pathdir%\%newdir%\shared
copy shared\*.* %pathdir%\%newdir%\shared\*.*

md %pathdir%\%newdir%\help
copy help\*.* %pathdir%\%newdir%\help\*.*

md %pathdir%\%newdir%\project
xcopy project\*.* %pathdir%\%newdir%\project\*.* /E

md %pathdir%\%newdir%\plugin
xcopy plugin\top64\*.* %pathdir%\%newdir%\plugin\top64\*.* /E
xcopy plugin\dock64\*.* %pathdir%\%newdir%\plugin\dock64\*.* /E
xcopy plugin\bk64\*.* %pathdir%\%newdir%\plugin\bk64\*.* /E
copy plugin\*.* %pathdir%\%newdir%\plugin\*.*


set newtime=
set newdate=
set hour=
set min=
set month=
set year=
set day=
set pathdir=
set newdir=

