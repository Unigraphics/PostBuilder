@echo off

REM==========================================================================
REM PB_HOME is the only env var referenced in the Post Builder source codes.
REM It should be set base on the Post Builder installation.
REM==========================================================================
set base=%1
set base_dir=%base:"=%
set PB_HOME=%base_dir%\postbuild

REM==========================================================================
REM UG DLL's search path.
REM==========================================================================
set PATH=%base_dir%\UGII;%PATH%

REM==========================================================================
REM Some vars for Tcl etc.
REM==========================================================================
set PB_TCL=%PB_HOME%\tcl

rem<01-21-08 gsl> Corrected env vars
rem set TCL_LIBRARY=%PB_TCL%\share\tcl8.0
rem set TK_LIBRARY=%PB_TCL%\share\tk8.0
rem set TIX_LIBRARY=%PB_TCL%\share\tix4.1

set TCL_LIBRARY=%PB_TCL%\share\tcl8.4
set TK_LIBRARY=%PB_TCL%\share\tk8.4
set TIX_LIBRARY=%PB_TCL%\share\tix8.4

REM==========================================================================
REM Tcl DLL search path
REM==========================================================================
set PATH=%PB_TCL%\exe;%PATH%

REM==========================================================================
REM Start Post Builder
REM==========================================================================
"%PB_HOME%\app\post_builder.exe" "%*"

REM==========================================================================
REM Post Builder returns 0 as the result of a successful run, otherwise
REM it returns a non-zero value.
REM==========================================================================
if ERRORLEVEL 0 goto END
  pause

:END
