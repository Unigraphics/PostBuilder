@echo off

REM========================настраиваемые переменные==========================

rem для NX1-nx4 !!!!!
set UGII_LICENSE_FILE=27000@%computername%
rem для NX6 !!!!!
set UGS_LICENSE_SERVER=28000@%computername%

Set USERNAME=Admin
rem любой 'левый' путь - без кириллицы
set UGII_BASE_DIR=C:\UGNX6\

rem set PB_HOME=%cd%
set PB_HOME=.\POSTBUILD

rem =============================================

set PB_TCL=%PB_HOME%\tcl

REM==========================================================================
REM Tcl DLL search path
REM==========================================================================
set PATH=%PB_TCL%\exe;%PATH%

rem<01-21-08 gsl> Corrected env vars
set TCL_LIBRARY=%PB_TCL%\share\tcl8.4
set TK_LIBRARY=%PB_TCL%\share\tk8.4
set TIX_LIBRARY=%PB_TCL%\share\tix8.4

"%PB_HOME%\app\Postino.exe" 2006061812 UG_POST_ADV_BLD "L N D" "%PB_HOME%"

if ERRORLEVEL 0 goto END
  pause

:END
