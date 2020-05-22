@echo off

REM========================настраиваемые переменные==========================

Set USERNAME=Admin
rem любой 'левый' путь - без кириллицы
set UGII_BASE_DIR=D:\UGNX4

set PB_HOME=.\POSTBUILD

REM==========================================================================

set PB_TCL=%PB_HOME%\tcl

REM==========================================================================
REM Tcl DLL search path
REM==========================================================================
set PATH=%PB_TCL%\exe;%PATH%

set TCL_LIBRARY=%PB_TCL%\share\tcl8.0
set TK_LIBRARY=%PB_TCL%\share\tk8.0
set TIX_LIBRARY=%PB_TCL%\share\tix4.1

rem Параметры
rem 1456928370  UG_POST_MILL  UG_POST_ADV_BLD

%PB_HOME%\app\Postino.exe 1456928370  UG_POST_MILL

if ERRORLEVEL 0 goto END
  pause

:END
