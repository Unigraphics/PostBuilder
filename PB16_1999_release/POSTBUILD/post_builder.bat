@echo off

REM==========================================================================
REM Set UGII_BASE_DIR & UGII_ROOT_DIR.
REM==========================================================================
call "..\UGII\SetEnv.bat"

REM==========================================================================
REM PB_HOME is the only env var referenced in the Post Builder source codes.
REM It should be set base on the Post Builder installation.
REM==========================================================================
set PB_HOME=%UGII_BASE_DIR%\postbuild

REM==========================================================================
REM UG DLL's search path.
REM==========================================================================
set PATH=%UGII_BASE_DIR%\UGII;%PATH%

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
%PB_HOME%\app\post_builder.exe
