@echo off

REM========================настраиваемые переменные==========================

set USERNAME=admin
set PB_HOME=.\POSTBUILD
rem любой 'левый' путь - без кириллицы
set UGII_BASE_DIR=C:\UG160

REM==========================================================================
REM Some vars for Tcl etc.
REM==========================================================================
set PB_TCL=%PB_HOME%\tcl
set TCL_LIBRARY=%PB_TCL%\share\tcl8.0
set TK_LIBRARY=%PB_TCL%\share\tk8.0
set TIX_LIBRARY=%PB_TCL%\share\tix4.1


REM==========================================================================
REM Tcl DLL search path
REM==========================================================================
set PATH=%PB_TCL%\exe;%PATH%

REM==========================================================================
REM Start Post Builder
REM==========================================================================

rem Параметры   "!$%^(@*#&)" UG_POST_MILL  UG_POST_ADV_BLD

%PB_HOME%\app\post_builder.exe

rem %PB_HOME%\app\Postino.exe  "!$%^(@*#&)" UG_POST_MILL

rem pause





